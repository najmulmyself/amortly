import 'package:equatable/equatable.dart';

class ExtraPaymentResult extends Equatable {
  final int monthsSaved;
  final double interestSaved;
  final DateTime newPayoffDate;
  final double newTotalInterest;
  final double originalTotalInterest;
  final int originalMonths;

  const ExtraPaymentResult({
    required this.monthsSaved,
    required this.interestSaved,
    required this.newPayoffDate,
    required this.newTotalInterest,
    required this.originalTotalInterest,
    required this.originalMonths,
  });

  @override
  List<Object?> get props => [
        monthsSaved,
        interestSaved,
        newPayoffDate,
        newTotalInterest,
        originalTotalInterest,
        originalMonths,
      ];
}
