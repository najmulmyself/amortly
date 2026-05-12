import 'package:equatable/equatable.dart';
import '../models/affordability_result.dart';

class AffordabilityState extends Equatable {
  final double monthlyIncome;
  final double monthlyDebts;
  final double downPayment;
  final double annualRate;
  final int termYears;
  final AffordabilityResult result;

  const AffordabilityState({
    required this.monthlyIncome,
    required this.monthlyDebts,
    required this.downPayment,
    required this.annualRate,
    required this.termYears,
    required this.result,
  });

  AffordabilityState copyWith({
    double? monthlyIncome,
    double? monthlyDebts,
    double? downPayment,
    double? annualRate,
    int? termYears,
    AffordabilityResult? result,
  }) {
    return AffordabilityState(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyDebts: monthlyDebts ?? this.monthlyDebts,
      downPayment: downPayment ?? this.downPayment,
      annualRate: annualRate ?? this.annualRate,
      termYears: termYears ?? this.termYears,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
        monthlyIncome,
        monthlyDebts,
        downPayment,
        annualRate,
        termYears,
        result,
      ];
}
