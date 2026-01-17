extension BankslipFormatter on String {
  String toBankslipFormat() {
    var s = replaceAll(RegExp(r'[^0-9]'), '');

    if (s.length != 47) return this;

    return '${s.substring(0, 5)}.${s.substring(5, 10)} '
           '${s.substring(10, 15)}.${s.substring(15, 21)} '
           '${s.substring(21, 26)}.${s.substring(26, 32)} '
           '${s.substring(32, 33)} '
           '${s.substring(33, 47)}';
  }
}