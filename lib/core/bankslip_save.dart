import 'package:hive_flutter/adapters.dart';

part "bankslip_save.g.dart";

@HiveType(typeId: 0)
class BankslipSave extends HiveObject {
  BankslipSave({required this.barcodes, required this.date, required this.totalValue});

  @HiveField(0)
  List<String> barcodes;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  double totalValue;
}