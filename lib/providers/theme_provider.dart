import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'app_theme';
  static const String _fontSizeKey = 'font_size';

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSizeScale = 1.0;

  ThemeMode get themeMode => _themeMode;
  double get fontSizeScale => _fontSizeScale;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = _getThemeModeFromString(savedTheme);
    }

    final savedFontSize = prefs.getDouble(_fontSizeKey);
    if (savedFontSize != null) {
      _fontSizeScale = savedFontSize;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());

    _themeMode = mode;
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  Future<void> setFontSizeScale(double scale) async {
    if (_fontSizeScale == scale) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, scale);

    _fontSizeScale = scale;
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final window = WidgetsBinding.instance.window;
      return window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
