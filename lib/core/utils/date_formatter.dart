import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _payoff = DateFormat('MMM yyyy');
  static final DateFormat _monthYearShort = DateFormat('MMM yy');
  static final DateFormat _long = DateFormat('MMM d, yyyy');

  /// Returns e.g. `"May 2056"`.
  static String payoffDate(DateTime date) => _payoff.format(date);

  /// Returns e.g. `"Jan 25"` for amortization table row labels.
  static String monthYearShort(DateTime date) => _monthYearShort.format(date);

  /// Returns e.g. `"May 12, 2025"`.
  static String longDate(DateTime date) => _long.format(date);
}
