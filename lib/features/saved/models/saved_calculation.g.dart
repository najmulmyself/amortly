// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_calculation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedCalculationAdapter extends TypeAdapter<SavedCalculation> {
  @override
  final int typeId = 0;

  @override
  SavedCalculation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedCalculation(
      id: fields[0] as String,
      name: fields[1] as String,
      homePrice: fields[2] as double,
      downPayment: fields[3] as double,
      loanAmount: fields[4] as double,
      annualRate: fields[5] as double,
      termYears: fields[6] as int,
      monthlyPayment: fields[7] as double,
      totalInterest: fields[8] as double,
      propertyTax: fields[9] as double,
      homeInsurance: fields[10] as double,
      pmi: fields[11] as double,
      savedAt: fields[12] as DateTime,
      notes: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedCalculation obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.homePrice)
      ..writeByte(3)
      ..write(obj.downPayment)
      ..writeByte(4)
      ..write(obj.loanAmount)
      ..writeByte(5)
      ..write(obj.annualRate)
      ..writeByte(6)
      ..write(obj.termYears)
      ..writeByte(7)
      ..write(obj.monthlyPayment)
      ..writeByte(8)
      ..write(obj.totalInterest)
      ..writeByte(9)
      ..write(obj.propertyTax)
      ..writeByte(10)
      ..write(obj.homeInsurance)
      ..writeByte(11)
      ..write(obj.pmi)
      ..writeByte(12)
      ..write(obj.savedAt)
      ..writeByte(13)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCalculationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
