class BankSlip {
  static final DateTime _dateTime = DateTime(2022, 5, 29);

  late String barcode;
  late DateTime date;
  late double value;

  BankSlip(this.barcode, this.date, this.value);

  static BankSlip createBankSlipDataUsingBarcode(String barcode) {
    DateTime actualTimeDate = _dateTime;

    if (barcode.length == 47) {
      actualTimeDate = actualTimeDate.add(Duration(days: int.parse(barcode.substring(33, 37))));
      final double value = double.parse(barcode.substring(37, 47)) / 100;
      return BankSlip(barcode, actualTimeDate, value);
    } else {
      actualTimeDate = actualTimeDate.add(Duration(days: int.parse(barcode.substring(5, 9))));
      final double value = double.parse(barcode.substring(9, 19)) / 100;
      return BankSlip(barcode, actualTimeDate, value);
    }
  }
}