import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme
  bool _systemIsDark = false; // Default value

  ThemeMode getThemeMode() => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    updateStatusBarStyle();
    notifyListeners();
  }

  void updateSystemTheme(bool isDark) {
    _systemIsDark = isDark;
  }

  void updateStatusBarStyle() {
    SystemUiOverlayStyle statusBarStyle = (_themeMode == ThemeMode.dark ||
            (_themeMode == ThemeMode.system && _systemIsDark))
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );

    SystemChrome.setSystemUIOverlayStyle(statusBarStyle);
  }

  void setRandomThemeMode() {
    final random = Random();
    const values = ThemeMode.values;
    setThemeMode(values[random.nextInt(values.length)]);
  }

  Future<void> initializeTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var storedTheme = preferences.getString('theme');
    if (storedTheme != null) {
      _themeMode = ThemeMode.values
          .firstWhere((e) => e.toString().split('.').last == storedTheme);
    }
    notifyListeners();
  }
}
