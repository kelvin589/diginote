import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class for retrieving and updating values of dark mode and background colour
/// from shared preferences.
class SharedPrefThemeManager {
  /// The key used to store dark mode state.
  static const isDarkModeKey = "isDarkMode";

  /// The key used to store background colour.
  static const backgroundColourKey = "backgroundColour";

  /// The default background colour (which is green).
  static const defaultBackgroundColour = Color.fromRGBO(0, 150, 136, 1);

  /// The default dark mode setting (which is false).
  static const defaultIsDarkMode = false;

  /// Sets the dark mode state.
  Future<void> setIsDarkMode(bool isDarkMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isDarkModeKey, isDarkMode);
  }

  /// Retrieves the dark mode setting from shared preferences.
  Future<bool> getIsDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isDarkModeKey) ?? defaultIsDarkMode;
  }

  /// Sets the background colour.
  Future<void> setBackgroundColour(Color backgroundColour) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(backgroundColourKey, backgroundColour.value);
  }

  /// Retreives the background colour from shared preferences.
  Future<int> getBackgroundColour() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(backgroundColourKey) ?? defaultBackgroundColour.value;
  }
}