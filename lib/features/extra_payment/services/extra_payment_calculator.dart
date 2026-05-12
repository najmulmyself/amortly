import 'dart:math';
import '../../calculator/models/mortgage_input.dart';
import '../models/extra_payment_result.dart';

class ExtraPaymentCalculator {
  /// Simulates the loan with [extraMonthly] added to each payment.
  /// Computes months saved, interest saved, and new payoff date.
  static ExtraPaymentResult calculate(
    MortgageInput input,
    double extraMonthly,
  ) {
    final n = input.termYears * 12;
    final r = input.annualRate / 100 / 12;
    final factor = pow(1 + r, n).toDouble();
    final basePayment = input.loanAmount * r * factor / (factor - 1);

    // Original total interest
    final originalTotalInterest = basePayment * n - input.loanAmount;

    if (extraMonthly <= 0) {
      return ExtraPaymentResult(
        monthsSaved: 0,
        interestSaved: 0,
        newPayoffDate: DateTime(
          input.startDate.year + input.termYears,
          input.startDate.month,
        ),
        newTotalInterest: originalTotalInterest,
        originalTotalInterest: originalTotalInterest,
        originalMonths: n,
      );
    }

    // Simulate with extra payment
    double balance = input.loanAmount;
    double newTotalInterest = 0;
    int monthsWithExtra = 0;

    while (balance > 0.005 && monthsWithExtra < n) {
      final interest = balance * r;
      double principal = basePayment + extraMonthly - interest;
      if (principal <= 0) principal = 0;
      if (principal > balance) principal = balance;
      balance = (balance - principal).clamp(0.0, double.infinity);
      newTotalInterest += interest;
      monthsWithExtra++;
    }

    final monthsSaved = n - monthsWithExtra;
    final interestSaved = (originalTotalInterest - newTotalInterest)
        .clamp(0, double.infinity)
        .toDouble();

    int payoffYear = input.startDate.year;
    int payoffMonth = input.startDate.month + monthsWithExtra;
    while (payoffMonth > 12) {
      payoffMonth -= 12;
      payoffYear++;
    }

    return ExtraPaymentResult(
      monthsSaved: monthsSaved,
      interestSaved: interestSaved,
      newPayoffDate: DateTime(payoffYear, payoffMonth),
      newTotalInterest: newTotalInterest.clamp(0, double.infinity),
      originalTotalInterest: originalTotalInterest.clamp(0, double.infinity),
      originalMonths: n,
    );
  }
}
