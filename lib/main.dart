import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pay_manager/l10n/app_localizations.dart";
import "package:pay_manager/pages/home_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const PayManagerApp()); 
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
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage()
      },
    );
  }
}