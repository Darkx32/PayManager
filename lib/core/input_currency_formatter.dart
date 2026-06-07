import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String cleanString = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanString.isEmpty) {
      return oldValue;
    }

    double value = double.parse(cleanString);

    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR", decimalDigits: 2);
    String newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}