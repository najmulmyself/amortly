import 'package:flutter_bloc/flutter_bloc.dart';
import '../../calculator/models/mortgage_input.dart';
import '../../calculator/services/mortgage_calculator.dart';
import 'compare_ab_state.dart';

class CompareAbCubit extends Cubit<CompareAbState> {
  CompareAbCubit(MortgageInput seedInput)
      : super(_build(
          loanA: seedInput,
          loanB: seedInput.copyWith(annualRate: seedInput.annualRate + 0.5),
        ));

  static CompareAbState _build({
    required MortgageInput loanA,
    required MortgageInput loanB,
  }) {
    return CompareAbState(
      loanA: loanA,
      loanB: loanB,
      resultA: MortgageCalculator.calculate(loanA),
      resultB: MortgageCalculator.calculate(loanB),
    );
  }

  // ── Loan A updates ───────────────────────────────────────────────────────

  void updateLoanAAmount(double amount) {
    emit(_build(
      loanA: state.loanA.copyWith(loanAmount: amount),
      loanB: state.loanB,
    ));
  }

  void updateLoanARate(double rate) {
    emit(_build(
      loanA: state.loanA.copyWith(annualRate: rate),
      loanB: state.loanB,
    ));
  }

  void updateLoanATerm(int years) {
    emit(_build(
      loanA: state.loanA.copyWith(termYears: years),
      loanB: state.loanB,
    ));
  }

  // ── Loan B updates ───────────────────────────────────────────────────────

  void updateLoanBAmount(double amount) {
    emit(_build(
      loanA: state.loanA,
      loanB: state.loanB.copyWith(loanAmount: amount),
    ));
  }

  void updateLoanBRate(double rate) {
    emit(_build(
      loanA: state.loanA,
      loanB: state.loanB.copyWith(annualRate: rate),
    ));
  }

  void updateLoanBTerm(int years) {
    emit(_build(
      loanA: state.loanA,
      loanB: state.loanB.copyWith(termYears: years),
    ));
  }
}
