import 'package:flutter/material.dart';
import 'package:pay_manager/core/backup_system.dart';
import 'package:pay_manager/l10n/app_localizations.dart';
import 'package:pay_manager/preferences.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const WidgetStateProperty<Icon> themeSwitchIcon = 
    WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
      WidgetState.selected: Icon(Icons.dark_mode),
      WidgetState.any: Icon(Icons.light_mode)
    });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings_title_page),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3)
                  )
                ],
                color: Theme.of(context).colorScheme.surfaceContainer,
                border: BoxBorder.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  strokeAlign: BorderSide.strokeAlignOutside
                ),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.settings_toggle_theme,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Spacer(),
                  Switch(value: isDarkMode, 
                    thumbIcon: themeSwitchIcon,
                    onChanged: (bool value) {
                      isDarkMode = value;
                      themeNotifier.toggleTheme();
                    })
                ],
              )
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16)
                    ),
                    onPressed: () { BackupSystem.importBackup(context, "bankslips"); },
                    child: const Icon(Icons.download, size: 30),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16)
                    ),
                    onPressed: () { BackupSystem.exportBackup(context, "bankslips"); }, 
                    child: const Icon(Icons.upload, size: 30),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}