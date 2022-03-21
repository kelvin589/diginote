import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefThemeManager {
  static const PREF_KEY_IS_DARK_MODE = "isDarkMode";
  static const PREF_KEY_BACKGROUND_COLOUR = "backgroundColour";

  Future<void> setIsDarkMode(bool isDarkMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_KEY_IS_DARK_MODE, isDarkMode);
  }

  Future<bool> getIsDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY_IS_DARK_MODE) ?? false;
  }

  Future<void> setBackgroundColour(Color backgroundColour) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(PREF_KEY_BACKGROUND_COLOUR, backgroundColour.value);
  }

  Future<int> getBackgroundColour() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(PREF_KEY_BACKGROUND_COLOUR) ?? 0;
  }
}