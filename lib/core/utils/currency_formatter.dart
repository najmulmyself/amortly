import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _whole = NumberFormat('#,###', 'en_US');
  static final NumberFormat _cents = NumberFormat('#,##0.00', 'en_US');

  /// Returns e.g. `$360,000` (no decimals).
  static String format(double value) => '\$${_whole.format(value.round())}';

  /// Returns e.g. `$2,216.52` (two decimals).
  static String formatWithCents(double value) => '\$${_cents.format(value)}';

  /// Returns compact label, e.g. `$360k`, `$1.2M`.
  static String formatCompact(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}k';
    return format(value);
  }

  /// Parses a string like `"$360,000"`, `"360,000"`, or `"360000"` to a double.
  static double parse(String value) {
    final clean = value.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }
}
