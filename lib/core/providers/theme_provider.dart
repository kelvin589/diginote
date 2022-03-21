import 'package:diginote/core/services/shared_preferences_theme_manager.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  SharedPrefThemeManager themeManager = SharedPrefThemeManager();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Color _backgroundColour = Colors.purple;
  Color get backgroundColour => _backgroundColour;

  init() async {
    await _getIsDarkMode();
    await _getBackgroundColour();
  }

  Future<void> toggleIsDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await themeManager.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setBackgroundColour(Color backgroundColour) async {
    _backgroundColour = backgroundColour;
    await themeManager.setBackgroundColour(backgroundColour);
    notifyListeners();
  }

  // Methods for initialising values of this class
  Future<void> _getIsDarkMode() async {
    _isDarkMode = await themeManager.getIsDarkMode();
    notifyListeners();
  }

  Future<void> _getBackgroundColour() async {
    _backgroundColour = Color(await themeManager.getBackgroundColour());
    notifyListeners();
  }
}