import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefThemeManager {
  static const isDarkModeKey = "isDarkMode";
  static const backgroundColourKey = "backgroundColour";
  static const defaultBackgroundColour = Color.fromRGBO(0, 150, 136, 1);
  static const defaultIsDarkMode = false;

  Future<void> setIsDarkMode(bool isDarkMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isDarkModeKey, isDarkMode);
  }

  Future<bool> getIsDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isDarkModeKey) ?? defaultIsDarkMode;
  }

  Future<void> setBackgroundColour(Color backgroundColour) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(backgroundColourKey, backgroundColour.value);
  }

  Future<int> getBackgroundColour() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(backgroundColourKey) ?? defaultBackgroundColour.value;
  }
}