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
