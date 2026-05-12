import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../services/affordability_calculator.dart';
import 'affordability_state.dart';

class AffordabilityCubit extends Cubit<AffordabilityState> {
  AffordabilityCubit() : super(_buildInitial());

  static AffordabilityState _buildInitial() {
    const income = 10000.0;
    const debts = 500.0;
    const down = 90000.0;
    const rate = 6.25;
    const term = 30;
    return AffordabilityState(
      monthlyIncome: income,
      monthlyDebts: debts,
      downPayment: down,
      annualRate: rate,
      termYears: term,
      result: AffordabilityCalculator.calculate(
        monthlyIncome: income,
        monthlyDebts: debts,
        downPayment: down,
        annualRate: rate,
        termYears: term,
      ),
    );
  }

  void updateIncome(String raw) => _recalculate(
        monthlyIncome: CurrencyFormatter.parse(raw),
      );

  void updateDebts(String raw) => _recalculate(
        monthlyDebts: CurrencyFormatter.parse(raw),
      );

  void updateDownPayment(String raw) => _recalculate(
        downPayment: CurrencyFormatter.parse(raw),
      );

  void updateRate(String raw) => _recalculate(
        annualRate: double.tryParse(raw) ?? state.annualRate,
      );

  void updateTerm(String raw) => _recalculate(
        termYears: int.tryParse(raw) ?? state.termYears,
      );

  void _recalculate({
    double? monthlyIncome,
    double? monthlyDebts,
    double? downPayment,
    double? annualRate,
    int? termYears,
  }) {
    final income = monthlyIncome ?? state.monthlyIncome;
    final debts = monthlyDebts ?? state.monthlyDebts;
    final down = downPayment ?? state.downPayment;
    final rate = annualRate ?? state.annualRate;
    final term = termYears ?? state.termYears;

    final result = AffordabilityCalculator.calculate(
      monthlyIncome: income,
      monthlyDebts: debts,
      downPayment: down,
      annualRate: rate,
      termYears: term,
    );

    emit(state.copyWith(
      monthlyIncome: income,
      monthlyDebts: debts,
      downPayment: down,
      annualRate: rate,
      termYears: term,
      result: result,
    ));
  }
}
