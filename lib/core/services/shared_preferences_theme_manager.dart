import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefThemeManager {
  static const PREF_KEY_IS_DARK_MODE = "isDarkMode";

  Future<void> setIsDarkMode(bool isDarkMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREF_KEY_IS_DARK_MODE, isDarkMode);
  }

  Future<bool> getIsDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREF_KEY_IS_DARK_MODE) ?? false;
  }
}