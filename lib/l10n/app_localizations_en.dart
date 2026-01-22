// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get date => 'Date';

  @override
  String get value => 'Value';

  @override
  String get confirm => 'Confirm';

  @override
  String get bankslip_page_dont_added_any_bankslip =>
      'You don\'t added any bankslip';

  @override
  String get bankslip_page_barcode => 'Barcode';

  @override
  String get bankslip_page_Amount => 'Amount';

  @override
  String get confirmation_popup_title => 'Confirmation';

  @override
  String get confirmation_popup_description =>
      'Do you really wants to make that?';

  @override
  String get confirmation_popup_yes => 'Yes';

  @override
  String get confirmation_popup_no => 'No';

  @override
  String get writebarcode_page_not_real_bankslip => 'It\'s no a real bankslip';

  @override
  String get scanner_page_barcode_detect => 'Barcode detect successfuly!';

  @override
  String get scanner_page_cancel => 'Cancel';
}
