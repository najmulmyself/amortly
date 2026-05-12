import 'dart:math';
import '../models/affordability_result.dart';

class AffordabilityCalculator {
  static const double _frontEndLimit = 0.28;
  static const double _backEndLimit = 0.36;

  /// Calculates the maximum affordable home price using standard DTI limits.
  ///
  /// - [monthlyIncome]: gross monthly household income
  /// - [monthlyDebts]: existing monthly debt payments (car, student loans, etc.)
  /// - [downPayment]: buyer's down payment
  /// - [annualRate]: annual interest rate (e.g. 6.25 for 6.25%)
  /// - [termYears]: loan term in years
  static AffordabilityResult calculate({
    required double monthlyIncome,
    required double monthlyDebts,
    required double downPayment,
    required double annualRate,
    required int termYears,
  }) {
    if (monthlyIncome <= 0 || annualRate <= 0 || termYears <= 0) {
      return const AffordabilityResult(
        maxHomePrice: 0,
        monthlyPayment: 0,
        frontEndDTI: 0,
        backEndDTI: 0,
        status: 'High',
      );
    }

    final n = termYears * 12;
    final r = annualRate / 100 / 12;
    final factor = pow(1 + r, n).toDouble();
    // Monthly payment factor: payment = loan * factor_p
    final factorP = r * factor / (factor - 1);

    // Front-end: max monthly P&I = 28% of income
    final maxPaymentFront = monthlyIncome * _frontEndLimit;
    final maxLoanFront = maxPaymentFront / factorP;
    final maxHomeFront = maxLoanFront + downPayment;

    // Back-end: max monthly P&I = 36% of income − existing debts
    final maxPaymentBack = (monthlyIncome * _backEndLimit - monthlyDebts)
        .clamp(0, double.infinity)
        .toDouble();
    final maxLoanBack = maxPaymentBack / factorP;
    final maxHomeBack = maxLoanBack + downPayment;

    final maxHomePrice = min(maxHomeFront, maxHomeBack);
    final loanAmount =
        (maxHomePrice - downPayment).clamp(0, double.infinity).toDouble();
    final monthlyPayment = loanAmount * factorP;

    final frontEndDTI =
        monthlyIncome > 0 ? (monthlyPayment / monthlyIncome) * 100 : 0.0;
    final backEndDTI = monthlyIncome > 0
        ? ((monthlyPayment + monthlyDebts) / monthlyIncome) * 100
        : 0.0;

    String status;
    if (frontEndDTI <= 28 && backEndDTI <= 36) {
      status = 'Good';
    } else if (frontEndDTI <= 33 && backEndDTI <= 43) {
      status = 'Fair';
    } else {
      status = 'High';
    }

    return AffordabilityResult(
      maxHomePrice: maxHomePrice.clamp(0, double.infinity).toDouble(),
      monthlyPayment: monthlyPayment.clamp(0, double.infinity).toDouble(),
      frontEndDTI: frontEndDTI.clamp(0, 100).toDouble(),
      backEndDTI: backEndDTI.clamp(0, 100).toDouble(),
      status: status,
    );
  }
}
