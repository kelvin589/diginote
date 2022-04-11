import 'package:diginote/core/services/shared_preferences_theme_manager.dart';
import 'package:flutter/material.dart';

/// A provider using the [SharedPrefThemeManager].
/// 
/// Manages the dark mode and background colour of the application.
class ThemeProvider extends ChangeNotifier {
  /// The [SharedPrefThemeManager] instance.
  SharedPrefThemeManager themeManager = SharedPrefThemeManager();

  /// The current dark mode state of the application.
  /// 
  /// If true, the application is in dark mode. 
  /// Otherwise the application is not in dark mode.
  bool _isDarkMode = false;

  /// Returns the current [_isDarkMode].
  bool get isDarkMode => _isDarkMode;

  /// The current background colour of the application.
  Color _backgroundColour = Colors.purple;

  /// Returns the current [_backgroundColour].
  Color get backgroundColour => _backgroundColour;

  /// Initialises the dark mode and background colour of the application
  /// by retrieving it from shared preferences.
  Future<void> init() async {
    await _getIsDarkMode();
    await _getBackgroundColour();
  }

  /// Toggles the dark mode.
  Future<void> toggleIsDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await themeManager.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }
  
  /// Sets the background colour.
  Future<void> setBackgroundColour(Color backgroundColour) async {
    _backgroundColour = backgroundColour;
    await themeManager.setBackgroundColour(backgroundColour);
    notifyListeners();
  }

  // Methods for initialising values of this class //
  /// Retrieves the dark mode setting from shared preferences.
  Future<void> _getIsDarkMode() async {
    _isDarkMode = await themeManager.getIsDarkMode();
    notifyListeners();
  }

  /// Retreives the background colour from shared preferences.
  Future<void> _getBackgroundColour() async {
    _backgroundColour = Color(await themeManager.getBackgroundColour());
    notifyListeners();
  }
}
