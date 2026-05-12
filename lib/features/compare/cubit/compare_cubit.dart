import 'package:flutter_bloc/flutter_bloc.dart';
import '../../calculator/models/mortgage_input.dart';
import '../../calculator/services/mortgage_calculator.dart';
import '../../extra_payment/services/extra_payment_calculator.dart';
import 'compare_state.dart';

class CompareCubit extends Cubit<CompareState> {
  CompareCubit(MortgageInput input) : super(_build(input, 200)) {
    // default extra = $200/mo
  }

  static CompareState _build(MortgageInput input, double extra) {
    final baseResult = MortgageCalculator.calculate(input);
    final epResult = ExtraPaymentCalculator.calculate(input, extra);
    return CompareState(
      input: input,
      extraMonthly: extra,
      result: epResult,
      baseMonthlyPI: baseResult.monthlyPI,
    );
  }

  void setExtra(double extra) {
    emit(_build(state.input, extra));
  }

  /// Called when the parent CalculatorCubit state changes.
  void updateInput(MortgageInput input) {
    emit(_build(input, state.extraMonthly));
  }
}
