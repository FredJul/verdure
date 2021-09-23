import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ObjectExtension<T> on T {
  R let<R>(R Function(T) op) => op(this);
}

extension StringExtension on String {
  String capitalize() => length > 1 ? this[0].toUpperCase() + substring(1) : toUpperCase();
}

extension IterableExtension on Iterable? {
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
}

extension BuildContextExtension on BuildContext {
  void pushScreen<S extends Widget>(S screen) => Navigator.push(this, MaterialPageRoute<S>(builder: (context) => screen));

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension DoubleExtension on double {
  String toShortString(BuildContext context, int maxFractionDigits) {
    final formatter = NumberFormat.decimalPattern(Localizations.localeOf(context).languageCode)
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = maxFractionDigits;
    return formatter.format(this);
  }
}
