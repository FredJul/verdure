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

  /// `Rechercher un produit…`
  String get searchHint {
    return Intl.message(
      'Rechercher un produit…',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Notre alimentation a un impact considérable sur notre environnement et le réchauffement climatique, il est nécessaire d'agir.`
  String get whyReduceImpactExplanation {
    return Intl.message(
      'Notre alimentation a un impact considérable sur notre environnement et le réchauffement climatique, il est nécessaire d\'agir.',
      name: 'whyReduceImpactExplanation',
      desc: '',
      args: [],
    );
  }

  /// `En savoir plus >`
  String get learnMore {
    return Intl.message(
      'En savoir plus >',
      name: 'learnMore',
      desc: '',
      args: [],
    );
  }

  /// `Accueil`
  String get homeTitle {
    return Intl.message(
      'Accueil',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Vous n'avez pas encore scanné de produit`
  String get noScannedFood {
    return Intl.message(
      'Vous n\'avez pas encore scanné de produit',
      name: 'noScannedFood',
      desc: '',
      args: [],
    );
  }

  /// `Favoris`
  String get favoriteTitle {
    return Intl.message(
      'Favoris',
      name: 'favoriteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Aucun produit mis en favori`
  String get noFavoriteFood {
    return Intl.message(
      'Aucun produit mis en favori',
      name: 'noFavoriteFood',
      desc: '',
      args: [],
    );
  }

  /// `Produits scannés`
  String get scannedProducts {
    return Intl.message(
      'Produits scannés',
      name: 'scannedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Supprimer ce produit de la liste ?`
  String get deleteScannedProductMessage {
    return Intl.message(
      'Supprimer ce produit de la liste ?',
      name: 'deleteScannedProductMessage',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur s'est produite, merci de vérifier votre connexion.`
  String get searchError {
    return Intl.message(
      'Une erreur s\'est produite, merci de vérifier votre connexion.',
      name: 'searchError',
      desc: '',
      args: [],
    );
  }

  /// `Aucun produit trouvé`
  String get noSearchResult {
    return Intl.message(
      'Aucun produit trouvé',
      name: 'noSearchResult',
      desc: '',
      args: [],
    );
  }

  /// `Impact environnemental`
  String get environmentalImpact {
    return Intl.message(
      'Impact environnemental',
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

  /// `Certaines informations nécessaires pour un calcul précis ne sont pas renseignées.`
  String get missingEcoscoreDataWarning {
    return Intl.message(
      'Certaines informations nécessaires pour un calcul précis ne sont pas renseignées.',
      name: 'missingEcoscoreDataWarning',
      desc: '',
      args: [],
    );
  }

  /// `Valeurs nutritionnelles pour 100g`
  String get nutritionalValues {
    return Intl.message(
      'Valeurs nutritionnelles pour 100g',
      name: 'nutritionalValues',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur s'est produite lors du lancement du navigateur.`
  String get browserOpeningError {
    return Intl.message(
      'Une erreur s\'est produite lors du lancement du navigateur.',
      name: 'browserOpeningError',
      desc: '',
      args: [],
    );
  }

  /// `Ingrédients`
  String get ingredients {
    return Intl.message(
      'Ingrédients',
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

  /// `Emballage`
  String get packaging {
    return Intl.message(
      'Emballage',
      name: 'packaging',
      desc: '',
      args: [],
    );
  }

  /// `Sucres`
  String get sugars {
    return Intl.message(
      'Sucres',
      name: 'sugars',
      desc: '',
      args: [],
    );
  }

  /// `Matières grasses / Lipides`
  String get fat {
    return Intl.message(
      'Matières grasses / Lipides',
      name: 'fat',
      desc: '',
      args: [],
    );
  }

  /// `Acides gras saturés`
  String get saturatedFat {
    return Intl.message(
      'Acides gras saturés',
      name: 'saturatedFat',
      desc: '',
      args: [],
    );
  }

  /// `Sel`
  String get salt {
    return Intl.message(
      'Sel',
      name: 'salt',
      desc: '',
      args: [],
    );
  }

  /// `Voir les ingrédients >`
  String get seeIngredients {
    return Intl.message(
      'Voir les ingrédients >',
      name: 'seeIngredients',
      desc: '',
      args: [],
    );
  }

  /// `Faible impact`
  String get lowImpact {
    return Intl.message(
      'Faible impact',
      name: 'lowImpact',
      desc: '',
      args: [],
    );
  }

  /// `Impact modéré`
  String get moderateImpact {
    return Intl.message(
      'Impact modéré',
      name: 'moderateImpact',
      desc: '',
      args: [],
    );
  }

  /// `Fort impact`
  String get highImpact {
    return Intl.message(
      'Fort impact',
      name: 'highImpact',
      desc: '',
      args: [],
    );
  }

  /// `Données manquantes`
  String get unknownImpact {
    return Intl.message(
      'Données manquantes',
      name: 'unknownImpact',
      desc: '',
      args: [],
    );
  }

  /// `Une erreur s'est produite, veuillez réessayer`
  String get retry {
    return Intl.message(
      'Une erreur s\'est produite, veuillez réessayer',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Aucune alternative trouvée`
  String get noAlternativeFound {
    return Intl.message(
      'Aucune alternative trouvée',
      name: 'noAlternativeFound',
      desc: '',
      args: [],
    );
  }

  /// `Les informations proviennent de la base de données collaborative Open Food Facts.`
  String get dataSource {
    return Intl.message(
      'Les informations proviennent de la base de données collaborative Open Food Facts.',
      name: 'dataSource',
      desc: '',
      args: [],
    );
  }

  /// `Vous pouvez consulter les informations détaillées de ce produit sur sa page dédiée et contribuer en ajoutant les informations manquantes ou en les aidant financièrement.`
  String get dataModification {
    return Intl.message(
      'Vous pouvez consulter les informations détaillées de ce produit sur sa page dédiée et contribuer en ajoutant les informations manquantes ou en les aidant financièrement.',
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
