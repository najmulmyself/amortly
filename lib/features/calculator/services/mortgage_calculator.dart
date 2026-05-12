import 'dart:math';
import '../models/mortgage_input.dart';
import '../models/mortgage_result.dart';

class MortgageCalculator {
  /// Standard fixed-rate mortgage formula:
  ///   M = P · r(1+r)^n / [(1+r)^n − 1]
  ///   r = annualRate / 100 / 12
  ///   n = termYears * 12
  static MortgageResult calculate(MortgageInput input) {
    final n = input.termYears * 12;
    final monthlyPI = _monthlyPI(input.loanAmount, input.annualRate, n);

    final monthlyTax = input.propertyTaxAnnual / 12;
    final monthlyInsurance = input.insuranceAnnual / 12;
    final monthlyPMI = input.pmiAnnual / 12;

    final extras = input.includeInPayment
        ? monthlyTax + monthlyInsurance + monthlyPMI
        : 0.0;

    final totalMonthly = monthlyPI + extras;
    final totalInterest = monthlyPI * n - input.loanAmount;
    final totalCost =
        input.loanAmount + totalInterest.clamp(0, double.infinity);
    final principalPercent =
        totalCost > 0 ? (input.loanAmount / totalCost) * 100 : 0.0;

    final payoffDate = DateTime(
      input.startDate.year + input.termYears,
      input.startDate.month,
    );

    return MortgageResult(
      monthlyPI: monthlyPI,
      totalMonthly: totalMonthly,
      totalInterest: totalInterest.clamp(0, double.infinity).toDouble(),
      totalCost: totalCost,
      principalPercent: principalPercent,
      payoffDate: payoffDate,
    );
  }

  /// Compute monthly P&I payment for a loan.
  static double _monthlyPI(double principal, double annualRate, int n) {
    if (principal <= 0 || n <= 0) return 0;
    if (annualRate == 0)
      return principal / n; // 0% interest: equal principal payments
    final r = annualRate / 100 / 12;
    final factor = pow(1 + r, n).toDouble();
    return principal * r * factor / (factor - 1);
  }

  /// Public helper so other calculators can reuse it.
  static double monthlyPayment(
      double principal, double annualRate, int termYears) {
    return _monthlyPI(principal, annualRate, termYears * 12);
  }
}
