import 'dart:math';
import '../../calculator/models/mortgage_input.dart';
import '../models/amortization_row.dart';

class AmortizationCalculator {
  /// Builds a full monthly amortization schedule (one row per month).
  static List<AmortizationRow> buildMonthly(MortgageInput input) {
    if (input.loanAmount <= 0 ||
        input.annualRate <= 0 ||
        input.termYears <= 0) {
      return [];
    }
    final n = input.termYears * 12;
    final r = input.annualRate / 100 / 12;
    final factor = pow(1 + r, n).toDouble();
    final payment = input.loanAmount * r * factor / (factor - 1);

    final rows = <AmortizationRow>[];
    double balance = input.loanAmount;
    int year = input.startDate.year;
    int month = input.startDate.month;

    for (int i = 1; i <= n && balance > 0.005; i++) {
      final interest = balance * r;
      double principal = payment - interest;
      if (principal > balance) principal = balance;
      balance = (balance - principal).clamp(0.0, double.infinity);

      rows.add(AmortizationRow(
        period: i,
        date: DateTime(year, month),
        payment: payment,
        principal: principal,
        interest: interest,
        balance: balance,
      ));

      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }
    return rows;
  }

  /// Aggregates monthly rows into yearly summary rows.
  /// Returns one row per year (period = year number, date = Jan of that year).
  static List<AmortizationRow> buildYearly(MortgageInput input) {
    final monthly = buildMonthly(input);
    if (monthly.isEmpty) return [];

    final n = input.termYears;
    final rows = <AmortizationRow>[];

    for (int yr = 1; yr <= n; yr++) {
      final yearRows =
          monthly.where((r) => ((r.period - 1) ~/ 12) + 1 == yr).toList();
      if (yearRows.isEmpty) continue;

      final totalPayment = yearRows.fold(0.0, (s, r) => s + r.payment);
      final totalPrincipal = yearRows.fold(0.0, (s, r) => s + r.principal);
      final totalInterest = yearRows.fold(0.0, (s, r) => s + r.interest);
      final endBalance = yearRows.last.balance;

      rows.add(AmortizationRow(
        period: yr,
        date: DateTime(input.startDate.year + yr - 1, 1),
        payment: totalPayment,
        principal: totalPrincipal,
        interest: totalInterest,
        balance: endBalance,
      ));
    }
    return rows;
  }
}
