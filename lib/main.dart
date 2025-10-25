import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pay_manager/l10n/app_localizations.dart";
import "package:pay_manager/pages/home_page.dart";
import "package:provider/provider.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiProvider(providers: [], child: const PayManagerApp())); 
}

class PayManagerApp extends StatefulWidget {
  const PayManagerApp({super.key});

  @override
  State<StatefulWidget> createState() => _PayManagerState();
}

class _PayManagerState extends State<PayManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PayManager",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light
        ),
        fontFamily: "Poppins"
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark
        ),
        fontFamily: "Poppins"
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        "/": (context) => const HomePage()
      },
    );
  }
}