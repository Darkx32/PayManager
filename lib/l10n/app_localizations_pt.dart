// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get date => 'Data';

  @override
  String get value => 'Valor';

  @override
  String get bankslip_page_dont_added_any_bankslip =>
      'Você não adicionou nenhum boleto';

  @override
  String get bankslip_page_barcode => 'Código de barras';

  @override
  String get confirmation_popup_title => 'Confirmação';

  @override
  String get confirmation_popup_description =>
      'Você realmente deseja fazer isso?';

  @override
  String get confirmation_popup_yes => 'Sim';

  @override
  String get confirmation_popup_no => 'Não';

  @override
  String get writebarcode_page_not_real_bankslip => 'Não é um boleto válido';

  @override
  String get writebarcode_page_confirm => 'Confirmar';
}
