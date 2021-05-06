import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension StringExtension on String {
  String capitalize() => length > 1 ? this[0].toUpperCase() + substring(1) : toUpperCase();
}

extension BuildContextExtension on BuildContext {
  void pushScreen<S extends Widget>(S screen) => Navigator.push(this, MaterialPageRoute<S>(builder: (context) => screen));

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppLocalizations get i18n => AppLocalizations.of(this)!;
}

extension ListExtension<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(int idx, E element) f) => asMap()
      .map(
        (idx, element) => MapEntry(
          idx,
          f(idx, element),
        ),
      )
      .values;

  E? firstWhereOrNull(bool Function(E element) test) {
    for (final e in this) {
      if (test(e)) {
        return e;
      }
    }

    return null;
  }
}

extension MapExtension<K, V> on Map<K, V> {
  Iterable<T> mapIndexed<T>(T Function(int idx, K key, V value) f) => keys
      .toList()
      .asMap()
      .map(
        (idx, key) => MapEntry(
          idx,
          f(idx, key, values.elementAt(idx)),
        ),
      )
      .values;
}

extension ColorExtension on Color {
  MaterialColor toMaterialColor() {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
}
