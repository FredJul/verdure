import 'dart:ui';

import 'package:ecoscore/common/extensions.dart';
import 'package:ecoscore/model/food.dart';
import 'package:openfoodfacts/model/parameter/SearchTerms.dart';
import 'package:openfoodfacts/model/parameter/TagFilter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:sorted/sorted.dart';

class OpenFoodFactsApi {
  OpenFoodFactsApi._();

  static const _productFields = [
    ProductField.BARCODE,
    ProductField.NAME,
    ProductField.BRANDS,
    ProductField.ECOSCORE_GRADE,
    ProductField.ECOSCORE_SCORE,
    ProductField.NUTRISCORE,
    ProductField.IMAGE_FRONT_URL,
    ProductField.IMAGE_FRONT_SMALL_URL,
    ProductField.IMAGE_INGREDIENTS_URL,
    ProductField.QUANTITY,
    ProductField.NUTRIMENTS,
    ProductField.NUTRIENT_LEVELS,
    ProductField.NUTRIMENT_ENERGY_UNIT,
    ProductField.ADDITIVES,
    ProductField.LABELS_TAGS,
    ProductField.CATEGORIES_TAGS,
  ];

  static Future<Food?> getFood(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      fields: _productFields,
      lc: window.locale.languageCode,
      cc: window.locale.countryCode,
    );

    final ProductResult result = await OpenFoodAPIClient.getProduct(configuration);
    return result.product?.toFood();
  }

  static Future<List<Food>> getBetterFoods(Food food) async {
    void removeWorseProducts(List<Product>? products) {
      products?.removeWhere((p) =>
          p.getFixedEcoscoreGrade() == null ||
          (food.ecoscoreGrade != null && p.getFixedEcoscoreGrade()!.compareTo(food.ecoscoreGrade!) > 0));
      products?.removeWhere((p) =>
          p.getFixedNutriscoreGrade() == null ||
          (food.nutriscoreGrade != null && p.getFixedNutriscoreGrade()!.compareTo(food.nutriscoreGrade!) > 0));
      products?.removeWhere(
          (p) => p.getFixedEcoscoreGrade() == food.ecoscoreGrade && p.getFixedNutriscoreGrade() == food.nutriscoreGrade);
    }

    List<Product>? products;

    // We first search for products in the same categories
    if (food.categoryTags.isNotEmpty) {
      final searchResult = await OpenFoodAPIClient.searchProducts(
        null,
        ProductSearchQueryConfiguration(
          fields: _productFields,
          parametersList: [
            const PageSize(size: 100),
            ...food.categoryTags.map((tag) => TagFilter(
                  tagType: 'categories',
                  contains: true,
                  tagName: tag,
                )),
            const SortBy(option: SortOption.POPULARITY),
          ],
          lc: window.locale.languageCode,
          cc: window.locale.countryCode,
        ),
      );

      products = searchResult.products;
      removeWorseProducts(products);
    }

    // If we do not find better alternatives, we try to search with the product name
    if ((products?.length ?? 0) == 0) {
      final searchResult = await OpenFoodAPIClient.searchProducts(
        null,
        ProductSearchQueryConfiguration(
          fields: _productFields,
          parametersList: [
            const PageSize(size: 100),
            SearchTerms(terms: [food.name]),
            const SortBy(option: SortOption.POPULARITY),
          ],
          lc: window.locale.languageCode,
          cc: window.locale.countryCode,
        ),
      );

      products = searchResult.products;
      removeWorseProducts(products);
    }

    products = products?.sorted([
      SortedComparable<Product, String>((p) => p.getFixedEcoscoreGrade()!),
      SortedComparable<Product, String>((p) => p.getFixedNutriscoreGrade()!),
    ]);

    return products?.take(20).map((p) => p.toFood()).toList() ?? [];
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
        lc: window.locale.languageCode,
        cc: window.locale.countryCode,
      ),
    );

    return searchResult.products?.map((p) => p.toFood()).toList() ?? [];
  }

  static String getEditUrl(Food food) {
    final isFr = window.locale.languageCode.toLowerCase() == 'fr';
    return 'https://${isFr ? 'fr' : 'world'}.openfoodfacts.org/cgi/product.pl?type=edit&code=${food.barcode}';
  }
}

extension _ProductExtension on Product {
  String? getFixedEcoscoreGrade() => ecoscoreGrade?.length == 1 ? ecoscoreGrade : null;
  String? getFixedNutriscoreGrade() => nutriscore?.length == 1 ? nutriscore : null;

  Food toFood() {
    // Normalize brands
    var brandsSet = brands?.isEmpty == true ? null : brands?.split(',').map((b) => b.trim().capitalize()).toSet();

    // Remove the ones which are included into others (like 'Gerblé' and 'Gerblé bio')
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

    return Food(
      barcode: barcode ?? '',
      name: productName ?? '',
      brands: brandsSet?.join(', '),
      imageFrontSmallUrl: imageFrontSmallUrl,
      imageFrontUrl: imageFrontUrl,
      imageIngredientsUrl: imageIngredientsUrl,
      ecoscoreGrade: getFixedEcoscoreGrade(),
      ecoscoreScore: ecoscoreScore,
      nutriscoreGrade: getFixedNutriscoreGrade(),
      quantity: quantity?.isEmpty == true ? null : quantity,
      categoryTags: categoriesTags ?? List.empty(growable: true),
    );
  }
}
