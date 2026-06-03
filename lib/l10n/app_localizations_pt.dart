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
  String get confirm => 'Confirmar';

  @override
  String get bankslip_page_dont_added_any_bankslip =>
      'Você não adicionou nenhum boleto';

  @override
  String get bankslip_page_barcode => 'Código de barras';

  @override
  String get bankslip_page_Amount => 'Quantidade';

  @override
  String get confirmation_popup_title => 'Confirmação';

  @override
  String get confirmation_popup_description =>
      'Você realmente deseja fazer isso?';

  @override
  String get confirmation_popup_exit_bankslip_page =>
      'Alterações não salvas. Deseja sair mesmo assim?';

  @override
  String get confirmation_popup_delete_home_page =>
      'Você tem certeza que deseja deletar isto?';

  @override
  String get confirmation_popup_yes => 'Sim';

  @override
  String get confirmation_popup_no => 'Não';

  @override
  String get writebarcode_page_not_real_bankslip => 'Não é um boleto válido';

  @override
  String get scanner_page_barcode_detect => 'Código de barras foi detectado!';

  @override
  String get scanner_page_cancel => 'Cancelar';

  @override
  String get settings_title_page => 'Configurações';

  @override
  String get settings_toggle_theme => 'Tema escuro';

  @override
  String get settings_toggle_repeated => 'Repetido';

  @override
  String get settings_enable_max => 'Filtro';

  @override
  String get settings_max_value => 'Valor máximo';

  @override
  String get backup_dont_have_data => 'Você não possui dados salvos';

  @override
  String get backup_locale_to_save => 'Onde você deseja salvar o seu backup?';

  @override
  String get backup_saved => 'Backup salvo com sucesso';

  @override
  String get backup_select_backup => 'Selecione o backup que deseja importar';

  @override
  String get backup_loaded => 'Backup carregado com sucesso';
}
