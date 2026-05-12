import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../services/ad_service.dart';
import '../models/mortgage_input.dart';
import '../services/mortgage_calculator.dart';
import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(_buildInitial());

  static CalculatorState _buildInitial() {
    final input = MortgageInput(
      homePrice: 450000,
      downPayment: 90000,
      loanAmount: 360000,
      annualRate: 6.25,
      termYears: 30,
      startDate: DateTime(2025, 5, 12),
      propertyTaxAnnual: 4500,
      insuranceAnnual: 1200,
      pmiAnnual: 0,
      includeInPayment: true,
    );
    return CalculatorState(
      input: input,
      result: MortgageCalculator.calculate(input),
      selectedPreset: 2,
    );
  }

  void updateHomePrice(String raw) {
    final price = CurrencyFormatter.parse(raw);
    final down = state.input.downPayment;
    final loan = (price - down).clamp(0.0, double.infinity);
    _update(state.input.copyWith(homePrice: price, loanAmount: loan));
  }

  void updateDownPayment(String raw) {
    final down = CurrencyFormatter.parse(raw);
    final price = state.input.homePrice;
    final loan = (price - down).clamp(0.0, double.infinity);
    _update(state.input.copyWith(downPayment: down, loanAmount: loan));
  }

  void updateLoanAmount(String raw) {
    final loan = CurrencyFormatter.parse(raw);
    final price = state.input.homePrice;
    final down = (price - loan).clamp(0.0, double.infinity);
    _update(state.input.copyWith(loanAmount: loan, downPayment: down));
  }

  void updateRate(String raw) {
    final rate = double.tryParse(raw) ?? state.input.annualRate;
    _update(state.input.copyWith(annualRate: rate));
  }

  void updateTerm(String raw) {
    final term = int.tryParse(raw) ?? state.input.termYears;
    _update(state.input.copyWith(termYears: term));
  }

  void updatePropertyTax(String raw) {
    final tax = CurrencyFormatter.parse(raw);
    _update(state.input.copyWith(propertyTaxAnnual: tax));
  }

  void updateInsurance(String raw) {
    final ins = CurrencyFormatter.parse(raw);
    _update(state.input.copyWith(insuranceAnnual: ins));
  }

  void updatePmi(String raw) {
    final pmi = CurrencyFormatter.parse(raw);
    _update(state.input.copyWith(pmiAnnual: pmi));
  }

  void updateIncludeInPayment(bool value) {
    _update(state.input.copyWith(includeInPayment: value));
  }

  /// Applies a quick preset (0=15yr, 1=20yr, 2=30yr, 3=FHA, 4=VA).
  void applyPreset(int index) {
    final homePrice = state.input.homePrice;
    MortgageInput updated;
    switch (index) {
      case 0: // 15yr
        updated = state.input.copyWith(termYears: 15);
        break;
      case 1: // 20yr
        updated = state.input.copyWith(termYears: 20);
        break;
      case 2: // 30yr
        updated = state.input.copyWith(termYears: 30);
        break;
      case 3: // FHA — 3.5% down
        final down = (homePrice * 0.035).roundToDouble();
        updated = state.input.copyWith(
          downPayment: down,
          loanAmount: (homePrice - down).clamp(0, double.infinity),
          termYears: 30,
        );
        break;
      case 4: // VA — 0% down
        updated = state.input.copyWith(
          downPayment: 0,
          loanAmount: homePrice,
          termYears: 30,
        );
        break;
      default:
        return;
    }
    emit(state.copyWith(
      input: updated,
      result: MortgageCalculator.calculate(updated),
      selectedPreset: index,
    ));
  }

  int _updateCount = 0;

  void _update(MortgageInput input) {
    _updateCount++;
    if (_updateCount % 3 == 0) {
      AdService().showInterstitial();
    }
    emit(state.copyWith(
      input: input,
      result: MortgageCalculator.calculate(input),
    ));
  }
}
