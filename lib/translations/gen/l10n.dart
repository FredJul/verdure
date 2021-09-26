// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Translation {
  Translation();

  static Translation? _current;

  static Translation get current {
    assert(_current != null,
        'No instance of Translation was loaded. Try to initialize the Translation delegate before accessing Translation.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Translation> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Translation();
      Translation._current = instance;

      return instance;
    });
  }

  static Translation of(BuildContext context) {
    final instance = Translation.maybeOf(context);
    assert(instance != null,
        'No instance of Translation present in the widget tree. Did you add Translation.delegate in localizationsDelegates?');
    return instance!;
  }

  static Translation? maybeOf(BuildContext context) {
    return Localizations.of<Translation>(context, Translation);
  }

  /// `Search a product…`
  String get searchHint {
    return Intl.message(
      'Search a product…',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Our food has a considerable impact on our environment and global warming, it is necessary to act.`
  String get whyReduceImpactExplanation {
    return Intl.message(
      'Our food has a considerable impact on our environment and global warming, it is necessary to act.',
      name: 'whyReduceImpactExplanation',
      desc: '',
      args: [],
    );
  }

  /// `Find out why >`
  String get learnMore {
    return Intl.message(
      'Find out why >',
      name: 'learnMore',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have not yet scanned a product`
  String get noScannedFood {
    return Intl.message(
      'You have not yet scanned a product',
      name: 'noScannedFood',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favoriteTitle {
    return Intl.message(
      'Favorites',
      name: 'favoriteTitle',
      desc: '',
      args: [],
    );
  }

  /// `No favorite product`
  String get noFavoriteFood {
    return Intl.message(
      'No favorite product',
      name: 'noFavoriteFood',
      desc: '',
      args: [],
    );
  }

  /// `Scanned products`
  String get scannedProducts {
    return Intl.message(
      'Scanned products',
      name: 'scannedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Remove this product from the list?`
  String get deleteScannedProductMessage {
    return Intl.message(
      'Remove this product from the list?',
      name: 'deleteScannedProductMessage',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred, please check your connection.`
  String get searchError {
    return Intl.message(
      'An error has occurred, please check your connection.',
      name: 'searchError',
      desc: '',
      args: [],
    );
  }

  /// `No product found`
  String get noSearchResult {
    return Intl.message(
      'No product found',
      name: 'noSearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Environmental impact`
  String get environmentalImpact {
    return Intl.message(
      'Environmental impact',
      name: 'environmentalImpact',
      desc: '',
      args: [],
    );
  }

  /// `Alternatives`
  String get alternatives {
    return Intl.message(
      'Alternatives',
      name: 'alternatives',
      desc: '',
      args: [],
    );
  }

  /// `Not applicable for this product.`
  String get notApplicableWarning {
    return Intl.message(
      'Not applicable for this product.',
      name: 'notApplicableWarning',
      desc: '',
      args: [],
    );
  }

  /// `Some information necessary for a precise calculation is not provided.`
  String get missingEcoscoreDataWarning {
    return Intl.message(
      'Some information necessary for a precise calculation is not provided.',
      name: 'missingEcoscoreDataWarning',
      desc: '',
      args: [],
    );
  }

  /// `Nutritional values per 100g`
  String get nutritionalValues {
    return Intl.message(
      'Nutritional values per 100g',
      name: 'nutritionalValues',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while launching the browser.`
  String get browserOpeningError {
    return Intl.message(
      'An error occurred while launching the browser.',
      name: 'browserOpeningError',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message(
      'Ingredients',
      name: 'ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get transportation {
    return Intl.message(
      'Transport',
      name: 'transportation',
      desc: '',
      args: [],
    );
  }

  /// `Packaging`
  String get packaging {
    return Intl.message(
      'Packaging',
      name: 'packaging',
      desc: '',
      args: [],
    );
  }

  /// `Sugars`
  String get sugars {
    return Intl.message(
      'Sugars',
      name: 'sugars',
      desc: '',
      args: [],
    );
  }

  /// `Fat`
  String get fat {
    return Intl.message(
      'Fat',
      name: 'fat',
      desc: '',
      args: [],
    );
  }

  /// `Saturated fat`
  String get saturatedFat {
    return Intl.message(
      'Saturated fat',
      name: 'saturatedFat',
      desc: '',
      args: [],
    );
  }

  /// `Salt`
  String get salt {
    return Intl.message(
      'Salt',
      name: 'salt',
      desc: '',
      args: [],
    );
  }

  /// `See the ingredients >`
  String get seeIngredients {
    return Intl.message(
      'See the ingredients >',
      name: 'seeIngredients',
      desc: '',
      args: [],
    );
  }

  /// `Low impact`
  String get lowImpact {
    return Intl.message(
      'Low impact',
      name: 'lowImpact',
      desc: '',
      args: [],
    );
  }

  /// `Moderate impact`
  String get moderateImpact {
    return Intl.message(
      'Moderate impact',
      name: 'moderateImpact',
      desc: '',
      args: [],
    );
  }

  /// `High impact`
  String get highImpact {
    return Intl.message(
      'High impact',
      name: 'highImpact',
      desc: '',
      args: [],
    );
  }

  /// `Missing data`
  String get unknownImpact {
    return Intl.message(
      'Missing data',
      name: 'unknownImpact',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred. Please try again.`
  String get retry {
    return Intl.message(
      'An error has occurred. Please try again.',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `No alternative found`
  String get noAlternativeFound {
    return Intl.message(
      'No alternative found',
      name: 'noAlternativeFound',
      desc: '',
      args: [],
    );
  }

  /// `The information comes from the collaborative Open Food Facts database.`
  String get dataSource {
    return Intl.message(
      'The information comes from the collaborative Open Food Facts database.',
      name: 'dataSource',
      desc: '',
      args: [],
    );
  }

  /// `You can view the detailed information of this product on its dedicated page and contribute by adding the missing information or helping them financially.`
  String get dataModification {
    return Intl.message(
      'You can view the detailed information of this product on its dedicated page and contribute by adding the missing information or helping them financially.',
      name: 'dataModification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Translation> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Translation> load(Locale locale) => Translation.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
