import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pay_manager/core/backup_system.dart';
import 'package:pay_manager/core/input_currency_formatter.dart';
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
  Timer? _debounce;

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
  void dispose() {
     _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final repeatedNotifier = context.watch<RepeatedNotifier>();
    final autoExclude = context.watch<AutoExclude>();

    bool isDarkMode = themeNotifier.isDarkMode;
    bool canRepeated = repeatedNotifier.canRepeated;
    bool canExclude = autoExclude.canExclude;
    double minimalValue = autoExclude.minimalValue;

    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR", decimalDigits: 2);
    String formattedText = formatter.format(minimalValue);

    final TextEditingController valueController = TextEditingController(text: formattedText);

    void saveOnSharedPreferences(String value) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        if (value.isEmpty) return;

        String apenasNumeros = value.replaceAll(RegExp(r'[^\d]'), '');
        if (apenasNumeros.isEmpty) return;

        double transformedValue = double.parse(apenasNumeros) / 100;

        autoExclude.setValue(transformedValue);
      });
    }

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
              },
            ),
            SettingsSwitcher(
              title: AppLocalizations.of(context)!.settings_toggle_repeated, 
              value: canRepeated, 
              switchIcon: acceptSwitchIcon, 
              onChange: (bool value) {
                canRepeated = value;
                repeatedNotifier.toggleRepeated();
              },
              tooltip: AppLocalizations.of(context)!.settings_toggle_repeated_tooltip
            ),
            SettingsSwitcher(
              title: AppLocalizations.of(context)!.settings_enable_max, 
              value: canExclude, 
              switchIcon: acceptSwitchIcon, 
              onChange: (bool value) {
                canExclude = value;
                autoExclude.toggleExclude();
              },
              tooltip: AppLocalizations.of(context)!.settings_max_tooltip,
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.settings_max_value, style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: TextField(
                      controller: valueController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        InputCurrencyFormatter()
                      ],
                      onChanged: (value) => saveOnSharedPreferences(value),
                    )
                  ),
                ],
              ),
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