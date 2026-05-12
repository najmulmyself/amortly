import 'package:equatable/equatable.dart';
import '../../calculator/models/mortgage_input.dart';
import '../../calculator/models/mortgage_result.dart';

class CalculatorState extends Equatable {
  final MortgageInput input;
  final MortgageResult result;
  final int selectedPreset;

  const CalculatorState({
    required this.input,
    required this.result,
    this.selectedPreset = 2,
  });

  CalculatorState copyWith({
    MortgageInput? input,
    MortgageResult? result,
    int? selectedPreset,
  }) {
    return CalculatorState(
      input: input ?? this.input,
      result: result ?? this.result,
      selectedPreset: selectedPreset ?? this.selectedPreset,
    );
  }

  @override
  List<Object?> get props => [input, result, selectedPreset];
}
