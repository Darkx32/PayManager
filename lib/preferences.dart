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

class AutoExclude extends ChangeNotifier {
  bool canExclude;
  double minimalValue;
  AutoExclude(this.canExclude, this.minimalValue);

  Future<void> toggleExclude() async {
    canExclude = !canExclude;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("canExclude", canExclude);
    notifyListeners();
  }

  Future<void> setValue(double value) async {
    minimalValue = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("minimalValue", minimalValue);
    notifyListeners();
  }
}