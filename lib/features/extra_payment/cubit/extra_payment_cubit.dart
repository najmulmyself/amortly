import 'package:flutter_bloc/flutter_bloc.dart';
import '../../calculator/models/mortgage_input.dart';
import '../services/extra_payment_calculator.dart';
import 'extra_payment_state.dart';

class ExtraPaymentCubit extends Cubit<ExtraPaymentState> {
  ExtraPaymentCubit(MortgageInput input)
      : super(ExtraPaymentState(
          input: input,
          result: ExtraPaymentCalculator.calculate(input, 200),
          extraMonthly: 200,
          paymentType: 0,
        ));

  void setExtra(double extra) {
    final result = ExtraPaymentCalculator.calculate(state.input, extra);
    emit(state.copyWith(extraMonthly: extra, result: result));
  }

  void setPaymentType(int type) {
    emit(state.copyWith(paymentType: type));
  }
}
