import 'package:hive/hive.dart';

part 'saved_calculation.g.dart';

@HiveType(typeId: 0)
class SavedCalculation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double homePrice;

  @HiveField(3)
  double downPayment;

  @HiveField(4)
  double loanAmount;

  @HiveField(5)
  double annualRate;

  @HiveField(6)
  int termYears;

  @HiveField(7)
  double monthlyPayment;

  @HiveField(8)
  double totalInterest;

  @HiveField(9)
  double propertyTax;

  @HiveField(10)
  double homeInsurance;

  @HiveField(11)
  double pmi;

  @HiveField(12)
  DateTime savedAt;

  @HiveField(13)
  String? notes;

  SavedCalculation({
    required this.id,
    required this.name,
    required this.homePrice,
    required this.downPayment,
    required this.loanAmount,
    required this.annualRate,
    required this.termYears,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.propertyTax,
    required this.homeInsurance,
    required this.pmi,
    required this.savedAt,
    this.notes,
  });
}
