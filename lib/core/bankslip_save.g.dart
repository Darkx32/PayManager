// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bankslip_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankslipSaveAdapter extends TypeAdapter<BankslipSave> {
  @override
  final int typeId = 0;

  @override
  BankslipSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankslipSave(
      barcodes: (fields[0] as List).cast<String>(),
      date: fields[1] as DateTime,
      totalValue: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BankslipSave obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.barcodes)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankslipSaveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
