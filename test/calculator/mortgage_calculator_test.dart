import 'package:flutter_test/flutter_test.dart';
import 'package:amortly/features/calculator/models/mortgage_input.dart';
import 'package:amortly/features/calculator/services/mortgage_calculator.dart';
import 'package:amortly/features/extra_payment/services/extra_payment_calculator.dart';
import 'package:amortly/features/affordability/services/affordability_calculator.dart';

void main() {
  group('MortgageCalculator', () {
    final input = MortgageInput(
      homePrice: 450000,
      downPayment: 90000,
      loanAmount: 360000,
      annualRate: 6.25,
      termYears: 30,
      startDate: DateTime(2025, 5, 12),
    );

    test('\$360k @ 6.25% 30yr: monthly P&I ≈ \$2,216.52', () {
      final result = MortgageCalculator.calculate(input);
      expect(result.monthlyPI, closeTo(2216.52, 2.0));
    });

    test('total interest is within expected range', () {
      final result = MortgageCalculator.calculate(input);
      expect(result.totalInterest, greaterThan(430000));
      expect(result.totalInterest, lessThan(445000));
    });

    test('principal percent is between 40% and 60%', () {
      final result = MortgageCalculator.calculate(input);
      expect(result.principalPercent, greaterThan(40));
      expect(result.principalPercent, lessThan(60));
    });

    test('payoff date is ~30 years after start', () {
      final result = MortgageCalculator.calculate(input);
      final diff = result.payoffDate.difference(input.startDate);
      final years = diff.inDays / 365.25;
      expect(years, closeTo(30, 0.5));
    });

    test('0% rate: returns 0 (edge case handled)', () {
      final zeroInput = input.copyWith(annualRate: 0);
      final result = MortgageCalculator.calculate(zeroInput);
      expect(result.monthlyPI, equals(0.0));
    });
  });

  group('ExtraPaymentCalculator', () {
    final input = MortgageInput(
      homePrice: 450000,
      downPayment: 90000,
      loanAmount: 360000,
      annualRate: 6.25,
      termYears: 30,
      startDate: DateTime(2025, 5, 12),
    );

    test('\$200/mo extra saves months and interest', () {
      final result = ExtraPaymentCalculator.calculate(input, 200);
      expect(result.monthsSaved, greaterThan(0));
      expect(result.interestSaved, greaterThan(0));
    });

    test('\$0 extra: no savings', () {
      final result = ExtraPaymentCalculator.calculate(input, 0);
      expect(result.monthsSaved, equals(0));
      expect(result.interestSaved, closeTo(0, 1.0));
    });

    test('\$500/mo extra saves more than \$200/mo extra', () {
      final r200 = ExtraPaymentCalculator.calculate(input, 200);
      final r500 = ExtraPaymentCalculator.calculate(input, 500);
      expect(r500.monthsSaved, greaterThan(r200.monthsSaved));
      expect(r500.interestSaved, greaterThan(r200.interestSaved));
    });
  });

  group('AffordabilityCalculator', () {
    test('maxHomePrice is reasonable for \$10k income', () {
      final result = AffordabilityCalculator.calculate(
        monthlyIncome: 10000,
        monthlyDebts: 500,
        downPayment: 90000,
        annualRate: 6.25,
        termYears: 30,
      );
      expect(result.maxHomePrice, greaterThan(200000));
      expect(result.maxHomePrice, lessThan(900000));
    });

    test('status is not High when DTI is at the recommended limit', () {
      final result = AffordabilityCalculator.calculate(
        monthlyIncome: 20000,
        monthlyDebts: 0,
        downPayment: 200000,
        annualRate: 6.25,
        termYears: 30,
      );
      // Calculator constrains max price to DTI limits, so status will be Good or Fair at boundary
      expect(result.status, isNot('High'));
      expect(result.frontEndDTI, lessThanOrEqualTo(29));
    });

    test('frontEndDTI and backEndDTI are positive', () {
      final result = AffordabilityCalculator.calculate(
        monthlyIncome: 10000,
        monthlyDebts: 500,
        downPayment: 90000,
        annualRate: 6.25,
        termYears: 30,
      );
      expect(result.frontEndDTI, greaterThan(0));
      expect(result.backEndDTI, greaterThan(result.frontEndDTI));
    });
  });
}
