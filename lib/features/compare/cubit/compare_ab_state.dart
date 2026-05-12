import 'package:equatable/equatable.dart';
import '../../calculator/models/mortgage_input.dart';
import '../../calculator/models/mortgage_result.dart';

/// State for the "Loan A vs Loan B" independent comparison screen.
class CompareAbState extends Equatable {
  final MortgageInput loanA;
  final MortgageInput loanB;
  final MortgageResult resultA;
  final MortgageResult resultB;

  const CompareAbState({
    required this.loanA,
    required this.loanB,
    required this.resultA,
    required this.resultB,
  });

  @override
  List<Object?> get props => [loanA, loanB, resultA, resultB];
}
