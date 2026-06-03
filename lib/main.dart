import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pay_manager/l10n/app_localizations.dart";
import "package:pay_manager/pages/home_page.dart";
import "package:pay_manager/pages/settings_page.dart";
import "package:pay_manager/preferences.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool("isDarkMode") ?? true;
  bool canRepeated = prefs.getBool("canRepeated") ?? true;

  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier(isDarkMode)),
      ChangeNotifierProvider(create: (_) => RepeatedNotifier(canRepeated))
    ], child: const PayManagerApp(),
  )); 
}

class PayManagerApp extends StatefulWidget {
  const PayManagerApp({super.key});

  @override
  State<StatefulWidget> createState() => _PayManagerState();
}

class _PayManagerState extends State<PayManagerApp> {
  @override
  Widget build(BuildContext context) {
    final Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final String languageCode = ["en", "pt"].contains(deviceLocale.languageCode) ? deviceLocale.languageCode : "pt";
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp(
      title: "PayManager",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageCode),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light
        ),
        fontFamily: "Poppins"
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark
        ),
        fontFamily: "Poppins"
      ),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage()
      },
    );
  }
}