import 'dart:collection';
import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:ecoscore/model/food.dart';
import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/CountryHelper.dart';

class OpenFoodFactsApi {
  OpenFoodFactsApi._();

  static const _productFields = [
    ProductField.BARCODE,
    ProductField.NAME,
    ProductField.BRANDS,
    ProductField.ECOSCORE_GRADE,
    ProductField.ECOSCORE_DATA,
    ProductField.NUTRISCORE,
    ProductField.IMAGE_FRONT_URL,
    ProductField.QUANTITY,
    ProductField.NUTRIMENTS,
    ProductField.NUTRIENT_LEVELS,
    ProductField.IMAGE_INGREDIENTS_URL,
    ProductField.CATEGORIES_TAGS,
  ];

  static OpenFoodFactsLanguage get _lc => LanguageHelper.fromJson(window.locale.languageCode);
  static OpenFoodFactsCountry? get _cc =>
      CountryHelper.fromJson(window.locale.countryCode == 'GB' ? 'uk' : 'fr'); // we only support this 2 countries for now

  static final _alternativesCache = HashMap<String, List<Food>>();

  static Future<Food?> getFood(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      fields: _productFields,
      language: _lc,
      country: _cc,
    );

    final ProductResult result = await OpenFoodAPIClient.getProduct(configuration);
    final food = result.product?.toFood();

    // We try to update the alternative foods cache
    if (food != null) {
      for (final cacheList in _alternativesCache.values) {
        cacheList.forEachIndexed((element, index) {
          if (element.barcode == food.barcode) {
            cacheList[index] = food;
          }
        });
      }
    }

    return food;
  }

  static Future<List<Food>> getAlternatives(Food food) async {
    if (_alternativesCache.containsKey(food.barcode)) {
      return Future.value(_alternativesCache[food.barcode]);
    }

    Future<SearchResult> search(Parameter param) {
      return OpenFoodAPIClient.searchProducts(
        null,
        ProductSearchQueryConfiguration(
          fields: _productFields,
          parametersList: [
            const PageSize(size: 100),
            param,
            const SortBy(option: SortOption.POPULARITY),
          ],
          language: _lc,
          country: _cc,
        ),
      );
    }

    void removeWorseProducts(List<Product>? products) {
      products?.removeWhere(
        (p) =>
            p.ecoscoreGradeEnum == null || (food.ecoscoreGrade != null && p.ecoscoreGradeEnum!.index > food.ecoscoreGrade!.index),
      );
      products?.removeWhere(
        (p) =>
            p.nutriscoreGradeEnum == null ||
            (food.nutriscoreGrade != null && p.nutriscoreGradeEnum!.index > food.nutriscoreGrade!.index),
      );
      products?.removeWhere((p) => p.ecoscoreGradeEnum == food.ecoscoreGrade && p.nutriscoreGradeEnum == food.nutriscoreGrade);
    }

    List<Product>? products;

    // We first search for products in the same category
    if (food.categoryTags.isNotEmpty) {
      final searchResult = await search(
        TagFilter.fromType(
          tagFilterType: TagFilterType.CATEGORIES,
          tagName: food.categoryTags.last, // The last category seems to be the most relevant
        ),
      );

      products = searchResult.products;
      removeWorseProducts(products);
    }

    // If we do not find better alternatives, we try to search with another category
    if ((products?.length ?? 0) == 0 && food.categoryTags.length >= 2) {
      final searchResult = await search(
        TagFilter.fromType(
          tagFilterType: TagFilterType.CATEGORIES,
          tagName: food.categoryTags[food.categoryTags.lastIndex - 1],
        ),
      );

      products = searchResult.products;
      removeWorseProducts(products);
    }

    // If we do not find better alternatives, we try to search with the product name
    if ((products?.length ?? 0) == 0) {
      final searchResult = await search(SearchTerms(terms: [food.name]));

      products = searchResult.products;
      removeWorseProducts(products);
    }

    products = products?.sortedBy((p) => p.ecoscoreGradeEnum!.index).thenBy((p) => p.nutriscoreGradeEnum!.index);

    final foods = products?.take(20).map((p) => p.toFood()).toList() ?? [];
    _alternativesCache[food.barcode] = foods;

    return foods;
  }

  static Future<List<Food>> search(String terms) async {
    final searchResult = await OpenFoodAPIClient.searchProducts(
      null,
      ProductSearchQueryConfiguration(
        fields: _productFields,
        parametersList: [
          const PageSize(size: 50),
          SearchTerms(terms: [terms]),
        ],
        language: _lc,
        country: _cc,
      ),
    );

    return searchResult.products?.map((p) => p.toFood()).toList() ?? [];
  }

  static String getViewUrl(Food food) => 'https://$_cc.openfoodfacts.org/product/${food.barcode}';
}

extension _ProductExtension on Product {
  static Grade? _gradeFromLetter(String? letter) {
    switch (letter) {
      case 'a':
      case 'A':
        return Grade.a;
      case 'b':
      case 'B':
        return Grade.b;
      case 'c':
      case 'C':
        return Grade.c;
      case 'd':
      case 'D':
        return Grade.d;
      case 'e':
      case 'E':
        return Grade.e;
      case 'not-applicable':
        return Grade.notApplicable;
      default:
        return null;
    }
  }

  Grade? get ecoscoreGradeEnum => _gradeFromLetter(ecoscoreGrade);
  Grade? get nutriscoreGradeEnum => _gradeFromLetter(nutriscore);

  Food toFood() {
    // Normalize brands
    var brandsSet = brands?.isEmpty == true ? null : brands?.split(',').map((b) => b.trim().capitalize()).toSet();

    // Remove the ones which are included into others (like 'Gerbl??' and 'Gerbl?? bio')
    final brandsList = brandsSet?.toList();
    for (int i = 0; i < (brandsList?.length ?? 0); i++) {
      final brand = brandsList!.elementAt(i);
      if (brandsList.sublist(i + 1).any((b) => b.contains(brand))) {
        brandsSet!.remove(brand);
      }
    }

    // We prefer null than empty
    if (brandsSet != null && brandsSet.isEmpty) {
      brandsSet = null;
    }

    ImpactLevel? nutrientLevelToImpactLevel(Level? level) {
      switch (level) {
        case Level.LOW:
          return ImpactLevel.low;
        case Level.MODERATE:
          return ImpactLevel.moderate;
        case Level.HIGH:
          return ImpactLevel.high;
        default:
          return null;
      }
    }

    // TODO not sure why but some scores seem to be negatives, for now we just ignore that
    double? normalizeScore(double? score) => score == null
        ? score
        : score < 0
            ? 0
            : score > 100
                ? 100
                : score;

    return Food(
      barcode: barcode ?? '',
      name: productName ?? '',
      brands: brandsSet?.join(', '),
      imageFrontUrl: imageFrontUrl,
      imageIngredientsUrl: imageIngredientsUrl,
      ecoscoreGrade: ecoscoreGradeEnum,
      ingredientsScore: normalizeScore(ecoscoreData?.agribalyse?.score),
      packagingScore: normalizeScore(ecoscoreData?.adjustments?.packaging?.score),
      transportationScore: normalizeScore(ecoscoreData?.adjustments?.originsOfIngredients?.transportationScore),
      missingEcoscoreDataWarning: ecoscoreData?.missingDataWarning ?? false,
      nutriscoreGrade: nutriscoreGradeEnum,
      sugarsQuantity: nutriments?.sugars,
      fatQuantity: nutriments?.fat,
      saturatedFatQuantity: nutriments?.saturatedFat,
      saltQuantity: nutriments?.salt,
      sugarsLevel: nutrientLevelToImpactLevel(nutrientLevels?.levels[NutrientLevels.NUTRIENT_SUGARS]),
      fatLevel: nutrientLevelToImpactLevel(nutrientLevels?.levels[NutrientLevels.NUTRIENT_FAT]),
      saturatedFatLevel: nutrientLevelToImpactLevel(nutrientLevels?.levels[NutrientLevels.NUTRIENT_SATURATED_FAT]),
      saltLevel: nutrientLevelToImpactLevel(nutrientLevels?.levels[NutrientLevels.NUTRIENT_SALT]),
      quantity: quantity?.isEmpty == true ? null : quantity,
      categoryTags: categoriesTags ?? List.empty(growable: true),
    );
  }
}
