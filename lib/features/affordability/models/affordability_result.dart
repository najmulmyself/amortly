import 'package:equatable/equatable.dart';

class AffordabilityResult extends Equatable {
  final double maxHomePrice;
  final double monthlyPayment;
  final double frontEndDTI;
  final double backEndDTI;
  final String status;

  const AffordabilityResult({
    required this.maxHomePrice,
    required this.monthlyPayment,
    required this.frontEndDTI,
    required this.backEndDTI,
    required this.status,
  });

  @override
  List<Object?> get props => [
        maxHomePrice,
        monthlyPayment,
        frontEndDTI,
        backEndDTI,
        status,
      ];
}
