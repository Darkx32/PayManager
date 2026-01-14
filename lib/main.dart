import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pay_manager/l10n/app_localizations.dart";
import "package:pay_manager/pages/home_page.dart";
import "package:pay_manager/preferences.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  String language = prefs.getString("language") ?? "en";

  runApp(ChangeNotifierProvider(
    create: (context) => LanguageNotifier(language), 
    child: const PayManagerApp())); 
}

class PayManagerApp extends StatefulWidget {
  const PayManagerApp({super.key});

  @override
  State<StatefulWidget> createState() => _PayManagerState();
}

class _PayManagerState extends State<PayManagerApp> {
  @override
  Widget build(BuildContext context) {
    final languageNotifier = context.watch<LanguageNotifier>();

    return MaterialApp(
      title: "PayManager",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageNotifier.language),
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