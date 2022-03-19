import 'package:diginote/core/services/shared_preferences_theme_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  SharedPrefThemeManager themeManager = SharedPrefThemeManager();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _getIsDarkMode();
  }

  Future<void> toggleIsDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await themeManager.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> _getIsDarkMode() async {
    _isDarkMode = await themeManager.getIsDarkMode();
  }
}