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
      'Do you really want to make that?';

  @override
  String get confirmation_popup_exit_bankslip_page =>
      'Unsaved changes. Exit anyway?';

  @override
  String get confirmation_popup_delete_home_page =>
      'Do you really want delete this?';

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

  @override
  String get settings_title_page => 'Settings';

  @override
  String get settings_toggle_theme => 'DarkMode';

  @override
  String get settings_toggle_repeated => 'Repeated';

  @override
  String get settings_toggle_repeated_tooltip =>
      'Disable repeated bankslips on scan page';

  @override
  String get settings_enable_max => 'Auto exclude';

  @override
  String get settings_max_value => 'Minimum value';

  @override
  String get settings_max_tooltip =>
      'Payment slips exceeding this amount are marked to not disappear automatically';

  @override
  String get backup_dont_have_data => 'No saved data found';

  @override
  String get backup_locale_to_save => 'Where do you want to save your backup?';

  @override
  String get backup_saved => 'Backup saved';

  @override
  String get backup_select_backup => 'Select a backup to import';

  @override
  String get backup_loaded => 'Backup loaded';
}
