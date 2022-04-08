import 'package:diginote/core/services/shared_preferences_theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  late SharedPrefThemeManager themeManager;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    themeManager = SharedPrefThemeManager();
  });

  test('isDark mode can be set and retrieved', () async {
    await themeManager.setIsDarkMode(true);
    expect(await themeManager.getIsDarkMode(), true);
  });

  test('isDark mode is set to the default value if it does not exist', () async {
    expect(await themeManager.getIsDarkMode(), SharedPrefThemeManager.defaultIsDarkMode);
  });

  test('background colour can be set and retrieved', () async {
    Color colour = Colors.red;
    await themeManager.setBackgroundColour(colour);
    expect(await themeManager.getBackgroundColour(), colour.value);
  });

  test('background colour is set to the default value if it does not exist', () async {
    expect(await themeManager.getBackgroundColour(), SharedPrefThemeManager.defaultBackgroundColour.value);
  });
}