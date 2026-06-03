import 'package:flutter/material.dart';
import 'package:pay_manager/core/backup_system.dart';
import 'package:pay_manager/helpers/settings_switcher.dart';
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

  static const WidgetStateProperty<Icon> acceptSwitchIcon = 
    WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon> {
      WidgetState.selected: Icon(Icons.done),
      WidgetState.any: Icon(Icons.close)
    });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final repeatedNotifier = context.watch<RepeatedNotifier>();

    bool isDarkMode = themeNotifier.isDarkMode;
    bool canRepeated = repeatedNotifier.canRepeated;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings_title_page),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 15,
          children: [
            SettingsSwitcher(
              title: AppLocalizations.of(context)!.settings_toggle_theme,
              value: isDarkMode, 
              switchIcon: themeSwitchIcon, 
              onChange: (bool value) {
                isDarkMode = value;
                themeNotifier.toggleTheme();
              }
            ),
            SettingsSwitcher(
              title: AppLocalizations.of(context)!.settings_toggle_repeated, 
              value: canRepeated, 
              switchIcon: acceptSwitchIcon, 
              onChange: (bool value) {
                canRepeated = value;
                repeatedNotifier.toggleRepeated();
              }
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