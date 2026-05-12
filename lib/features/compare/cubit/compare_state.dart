import 'package:equatable/equatable.dart';
import '../../calculator/models/mortgage_input.dart';
import '../../extra_payment/models/extra_payment_result.dart';

class CompareState extends Equatable {
  final MortgageInput input;
  final double extraMonthly;
  final ExtraPaymentResult result;

  /// Base monthly P&I (computed once from input).
  final double baseMonthlyPI;

  const CompareState({
    required this.input,
    required this.extraMonthly,
    required this.result,
    required this.baseMonthlyPI,
  });

  @override
  List<Object?> get props => [input, extraMonthly, result, baseMonthlyPI];
}
