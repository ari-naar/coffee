import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF795548);
  static const Color primaryLight = Color(0xFFA1887F);
  static const Color primaryDark = Color(0xFF5D4037);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary colors
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color onSecondary = Color(0xFF000000);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onBackground = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);

  // Surface colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color onSurface = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // Error colors
  static const Color error = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);

  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF2C2C2C);

  // Rating colors
  static const Color ratingBad = Color(0xFFE57373);
  static const Color ratingMedium = Color(0xFFFFB74D);
  static const Color ratingGood = Color(0xFF81C784);
  static const Color ratingExcellent = Color(0xFF4CAF50);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Shimmer effect colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Social colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);

  // Custom colors for coffee-related UI
  static const Color lightRoast = Color(0xFFD4B08C);
  static const Color mediumRoast = Color(0xFFA67B5B);
  static const Color darkRoast = Color(0xFF795548);
  static const Color espresso = Color(0xFF3E2723);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF795548),
    Color(0xFF5D4037),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF9800),
    Color(0xFFF57C00),
  ];

  // Helper method to create a material color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // Helper method to get color based on rating
  static Color getRatingColor(double rating) {
    if (rating >= 4.5) return ratingExcellent;
    if (rating >= 4.0) return ratingGood;
    if (rating >= 3.0) return ratingMedium;
    return ratingBad;
  }

  // Helper method to get color based on roast level
  static Color getRoastColor(String roastLevel) {
    switch (roastLevel.toLowerCase()) {
      case 'light':
        return lightRoast;
      case 'medium':
        return mediumRoast;
      case 'dark':
        return darkRoast;
      case 'espresso':
        return espresso;
      default:
        return mediumRoast;
    }
  }
}
