import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pay_manager/core/bankslip_save.dart';
import 'package:pay_manager/l10n/app_localizations.dart';

class BackupSystem {
  static void _snackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2)
      )
    );
  }

  static Future<void> exportBackup(BuildContext context, String boxName) async {
    final dir = await getApplicationDocumentsDirectory();
    final originalPath = File('${dir.path}/$boxName.hive');

    if (!await originalPath.exists()) {
      if (!context.mounted) return;
      _snackBar(context, AppLocalizations.of(context)!.backup_dont_have_data);
    }

    Uint8List fileBytes = await originalPath.readAsBytes();

    if (!context.mounted) return;
    String? targetPath = await FilePicker.saveFile(
      dialogTitle: AppLocalizations.of(context)!.backup_locale_to_save,
      fileName: "$boxName.hive",
      bytes: fileBytes
    );

    if (targetPath != null) {
      if (!context.mounted) return;
      _snackBar(context, AppLocalizations.of(context)!.backup_saved);
    }
  }

  static Future<void> importBackup(BuildContext context, String boxName) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      dialogTitle: AppLocalizations.of(context)!.backup_select_backup,
      type: FileType.custom,
      allowedExtensions: ['hive']
    );

    if (result != null && result.files.single.path != null) {
      final fileSelected = File(result.files.single.path!);

      final dir = await getApplicationDocumentsDirectory();
      final internalTarget = File("${dir.path}/$boxName.hive");

      if (Hive.isBoxOpen(boxName)) {
        await Hive.box<BankslipSave>(boxName).close();
      }
      await fileSelected.copy(internalTarget.path);

      await Hive.openBox<BankslipSave>(boxName);

      if (!context.mounted) return;
      _snackBar(context, AppLocalizations.of(context)!.backup_loaded);
    }
  }
}