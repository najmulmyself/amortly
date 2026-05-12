import 'package:equatable/equatable.dart';
import '../../calculator/models/mortgage_input.dart';
import '../models/extra_payment_result.dart';

class ExtraPaymentState extends Equatable {
  final MortgageInput input;
  final ExtraPaymentResult result;
  final double extraMonthly;
  final int paymentType;

  const ExtraPaymentState({
    required this.input,
    required this.result,
    required this.extraMonthly,
    required this.paymentType,
  });

  ExtraPaymentState copyWith({
    MortgageInput? input,
    ExtraPaymentResult? result,
    double? extraMonthly,
    int? paymentType,
  }) {
    return ExtraPaymentState(
      input: input ?? this.input,
      result: result ?? this.result,
      extraMonthly: extraMonthly ?? this.extraMonthly,
      paymentType: paymentType ?? this.paymentType,
    );
  }

  @override
  List<Object?> get props => [input, result, extraMonthly, paymentType];
}
