import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Poppins';

  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.27,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    leadingDistribution: TextLeadingDistribution.even,
  );

  // Helper methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  // Common text styles
  static TextStyle get appBarTitle => titleLarge.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get cardTitle => titleMedium.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get cardSubtitle => bodyMedium.copyWith(
        color: AppColors.onSurface.withOpacity(0.6),
      );

  static TextStyle get buttonText => labelLarge.copyWith(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get inputLabel => labelMedium.copyWith(
        color: AppColors.onSurface.withOpacity(0.8),
      );

  static TextStyle get inputText => bodyLarge;

  static TextStyle get inputError => bodySmall.copyWith(
        color: AppColors.error,
      );

  static TextStyle get chipText => labelMedium.copyWith(
        color: AppColors.onSurface,
      );

  static TextStyle get listTitle => titleMedium.copyWith(
        color: AppColors.onSurface,
      );

  static TextStyle get listSubtitle => bodyMedium.copyWith(
        color: AppColors.onSurface.withOpacity(0.6),
      );

  static TextStyle get price => titleLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get rating => labelLarge.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      );
}
