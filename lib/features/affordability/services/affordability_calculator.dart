import 'dart:math';
import '../models/affordability_result.dart';

class AffordabilityCalculator {
  static const double _frontEndLimit = 0.28;
  static const double _backEndLimit = 0.36;

  // Spec §6.4 default assumptions for tax + insurance (annual % of home price)
  static const double _propertyTaxRate = 0.01; // 1.0%
  static const double _insuranceRate = 0.005; // 0.5%

  /// Calculates the maximum affordable home price using standard DTI limits,
  /// iterating to include property tax + insurance in the housing-cost cap
  /// per spec §6.4.
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
    if (monthlyIncome <= 0 || annualRate < 0 || termYears <= 0) {
      return const AffordabilityResult(
        maxHomePrice: 0,
        monthlyPayment: 0,
        frontEndDTI: 0,
        backEndDTI: 0,
        status: 'High',
      );
    }

    final n = termYears * 12;

    // Payment factor (handles annualRate == 0)
    final double factorP;
    if (annualRate == 0) {
      factorP = 1.0 / n;
    } else {
      final r = annualRate / 100 / 12;
      final factor = pow(1 + r, n).toDouble();
      factorP = r * factor / (factor - 1);
    }

    // Front-end cap: 28% of income covers P&I + tax + insurance
    final maxHousingFront = monthlyIncome * _frontEndLimit;
    // Back-end cap: (36% of income − debts) covers P&I + tax + insurance
    final maxHousingBack = (monthlyIncome * _backEndLimit - monthlyDebts)
        .clamp(0, double.infinity);

    final maxHousing = min(maxHousingFront, maxHousingBack);

    // Iterative solver: estimate price → compute T&I → solve for P&I budget → repeat
    // Converges in 3–5 iterations.
    double homePrice =
        maxHousing / factorP + downPayment; // initial estimate (no T&I)
    for (int i = 0; i < 5; i++) {
      final monthlyTI = homePrice * (_propertyTaxRate + _insuranceRate) / 12;
      final pibudget = (maxHousing - monthlyTI).clamp(0, double.infinity);
      final loan = pibudget / factorP;
      homePrice = loan + downPayment;
    }

    final loanAmount = (homePrice - downPayment).clamp(0, double.infinity);
    final monthlyPI = loanAmount * factorP;
    final monthlyTI = homePrice * (_propertyTaxRate + _insuranceRate) / 12;
    final totalHousing = monthlyPI + monthlyTI;

    // DTI uses total housing cost (P&I + T&I) in numerator
    final frontEndDTI =
        monthlyIncome > 0 ? (totalHousing / monthlyIncome) * 100 : 0.0;
    final backEndDTI = monthlyIncome > 0
        ? ((totalHousing + monthlyDebts) / monthlyIncome) * 100
        : 0.0;

    // Round to 1 decimal before comparing to avoid floating-point boundary flip
    final frontRounded = double.parse(frontEndDTI.toStringAsFixed(1));
    final backRounded = double.parse(backEndDTI.toStringAsFixed(1));

    final String status;
    if (frontRounded <= 28.0 && backRounded <= 36.0) {
      status = 'Good';
    } else if (frontRounded <= 33.0 && backRounded <= 43.0) {
      status = 'Fair';
    } else {
      status = 'High';
    }

    return AffordabilityResult(
      maxHomePrice: homePrice.clamp(0, double.infinity),
      monthlyPayment: monthlyPI.clamp(0, double.infinity),
      frontEndDTI: frontEndDTI.clamp(0, 100),
      backEndDTI: backEndDTI.clamp(0, 100),
      status: status,
    );
  }
}
