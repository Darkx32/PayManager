import 'package:flutter/material.dart';

class ConfirmationPopup {
  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Do you really wants to make that?"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(true); 
            }, child: const Text("Yes")),
            TextButton(onPressed: () {
              Navigator.of(context).pop(false); 
            }, child: const Text("No")),
          ],
        );
      },
    );
  }
}