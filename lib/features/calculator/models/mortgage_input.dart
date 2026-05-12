import 'package:equatable/equatable.dart';

class MortgageInput extends Equatable {
  final double homePrice;
  final double downPayment;
  final double loanAmount;
  final double annualRate;
  final int termYears;
  final DateTime startDate;
  final double propertyTaxAnnual;
  final double insuranceAnnual;
  final double pmiAnnual;
  final bool includeInPayment;

  const MortgageInput({
    required this.homePrice,
    required this.downPayment,
    required this.loanAmount,
    required this.annualRate,
    required this.termYears,
    required this.startDate,
    this.propertyTaxAnnual = 0,
    this.insuranceAnnual = 0,
    this.pmiAnnual = 0,
    this.includeInPayment = true,
  });

  MortgageInput copyWith({
    double? homePrice,
    double? downPayment,
    double? loanAmount,
    double? annualRate,
    int? termYears,
    DateTime? startDate,
    double? propertyTaxAnnual,
    double? insuranceAnnual,
    double? pmiAnnual,
    bool? includeInPayment,
  }) {
    return MortgageInput(
      homePrice: homePrice ?? this.homePrice,
      downPayment: downPayment ?? this.downPayment,
      loanAmount: loanAmount ?? this.loanAmount,
      annualRate: annualRate ?? this.annualRate,
      termYears: termYears ?? this.termYears,
      startDate: startDate ?? this.startDate,
      propertyTaxAnnual: propertyTaxAnnual ?? this.propertyTaxAnnual,
      insuranceAnnual: insuranceAnnual ?? this.insuranceAnnual,
      pmiAnnual: pmiAnnual ?? this.pmiAnnual,
      includeInPayment: includeInPayment ?? this.includeInPayment,
    );
  }

  @override
  List<Object?> get props => [
        homePrice,
        downPayment,
        loanAmount,
        annualRate,
        termYears,
        startDate,
        propertyTaxAnnual,
        insuranceAnnual,
        pmiAnnual,
        includeInPayment,
      ];
}
