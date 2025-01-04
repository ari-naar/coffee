import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_service.dart';

class ThemeService extends BaseService {
  // Singleton instance
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Constants
  static const String _themeKey = 'app_theme';
  static const String _fontSizeKey = 'font_size';

  // Theme mode notifier
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  // Font size scale notifier
  final ValueNotifier<double> fontSizeScale = ValueNotifier(1.0);

  // Initialize theme service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        themeMode.value = _getThemeModeFromString(savedTheme);
      }

      // Load font size scale
      final savedFontSize = prefs.getDouble(_fontSizeKey);
      if (savedFontSize != null) {
        fontSizeScale.value = savedFontSize;
      }

      logInfo('Theme service initialized');
    } catch (e) {
      logError('Failed to initialize theme service', e);
      rethrow;
    }
  }

  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
      themeMode.value = mode;
      logInfo('Theme mode updated: $mode');
    } catch (e) {
      logError('Failed to set theme mode', e);
      rethrow;
    }
  }

  // Toggle theme mode
  Future<void> toggleThemeMode() async {
    final newMode =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  // Set font size scale
  Future<void> setFontSizeScale(double scale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, scale);
      fontSizeScale.value = scale;
      logInfo('Font size scale updated: $scale');
    } catch (e) {
      logError('Failed to set font size scale', e);
      rethrow;
    }
  }

  // Reset theme settings
  Future<void> resetThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeKey);
      await prefs.remove(_fontSizeKey);

      themeMode.value = ThemeMode.system;
      fontSizeScale.value = 1.0;

      logInfo('Theme settings reset to default');
    } catch (e) {
      logError('Failed to reset theme settings', e);
      rethrow;
    }
  }

  // Helper method to convert string to ThemeMode
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

  // Get current theme mode
  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      // Get system theme mode
      final window = WidgetsBinding.instance.window;
      return window.platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }

  // Get current font size scale
  double get currentFontSizeScale => fontSizeScale.value;

  // Dispose resources
  void dispose() {
    themeMode.dispose();
    fontSizeScale.dispose();
  }
}
