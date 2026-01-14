import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankSlip {
  static final DateTime _dateTime = DateTime(2022, 5, 29);

  late String barcode;
  late DateTime date;
  late double value;

  static final _currencyFormat = NumberFormat.currency(
    locale: "pt_BR",
    symbol: "R\$",
    decimalDigits: 2
  );

  BankSlip(this.barcode, this.date, this.value);

  String getCurrencyToString() {
    return convertNumberToStringWithCurrency(value);
  }

  static String convertNumberToStringWithCurrency(double number) {
    return _currencyFormat.format(number);
  }

  static BankSlip createBankSlipDataUsingBarcode(String barcode) {
    DateTime actualTimeDate = _dateTime;
    String actualBarcode = barcode;

    if (barcode.length != 47) {
      actualBarcode = _convertBarcodeToDigitableLine(barcode);
    }

    debugPrint(actualBarcode);

    actualTimeDate = actualTimeDate.add(Duration(days: int.parse(actualBarcode.substring(33, 37))));
    final double value = double.parse(actualBarcode.substring(37, 47)) / 100;
    return BankSlip(actualBarcode, actualTimeDate, value);
  }


  static String _convertBarcodeToDigitableLine(String barcode) {
    String field1Base = barcode.substring(0, 4) + barcode.substring(19, 24);
    String field1Dv = _calculateMod10(field1Base);
    String field1 = "${field1Base.substring(0, 5)}${field1Base.substring(5)}$field1Dv";

    String field2Base = barcode.substring(24, 34);
    String field2Dv = _calculateMod10(field2Base);
    String field2 = "${field2Base.substring(0, 5)}${field2Base.substring(5)}$field2Dv";

    String field3Base = barcode.substring(34, 44);
    String field3Dv = _calculateMod10(field3Base);
    String field3 = "${field3Base.substring(0, 5)}${field3Base.substring(5)}$field3Dv";

    String field4 = barcode.substring(4, 5);

    String field5 = barcode.substring(5, 19);

    return "$field1$field2$field3$field4$field5";
  }

  static String _calculateMod10(String number) {
    int sum = 0;
    int weight = 2;
    
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);
      int product = digit * weight;

      if (product > 9) {
        product = (product ~/ 10) + (product % 10);
      }

      sum += product;
      weight = (weight == 2) ? 1 : 2;
    }

    int remainder = sum % 10;
    int checkDigit = (10 - remainder) % 10;
    
    return checkDigit.toString();
  }
}