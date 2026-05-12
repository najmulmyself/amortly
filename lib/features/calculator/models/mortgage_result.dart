import 'package:equatable/equatable.dart';

class MortgageResult extends Equatable {
  final double monthlyPI;
  final double totalMonthly;
  final double totalInterest;
  final double totalCost;
  final double principalPercent;
  final DateTime payoffDate;

  const MortgageResult({
    required this.monthlyPI,
    required this.totalMonthly,
    required this.totalInterest,
    required this.totalCost,
    required this.principalPercent,
    required this.payoffDate,
  });

  @override
  List<Object?> get props => [
        monthlyPI,
        totalMonthly,
        totalInterest,
        totalCost,
        principalPercent,
        payoffDate,
      ];
}
