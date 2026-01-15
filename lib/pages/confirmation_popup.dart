import 'package:flutter/material.dart';
import 'package:pay_manager/l10n/app_localizations.dart';

class ConfirmationPopup {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation_popup_title),
          content: Text(AppLocalizations.of(context)!.confirmation_popup_description),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(true); 
            }, child: Text(AppLocalizations.of(context)!.confirmation_popup_yes)),
            TextButton(onPressed: () {
              Navigator.of(context).pop(false); 
            }, child: Text(AppLocalizations.of(context)!.confirmation_popup_no)),
          ],
        );
      },
    );
  }
}