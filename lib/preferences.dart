import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode;
  ThemeNotifier(this.isDarkMode);

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", isDarkMode);
    notifyListeners();
  }
}

class RepeatedNotifier extends ChangeNotifier {
  bool canRepeated;
  RepeatedNotifier(this.canRepeated);

  Future<void> toggleRepeated() async {
    canRepeated = !canRepeated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("canRepeated", canRepeated);
    notifyListeners();
  }
}