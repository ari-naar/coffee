import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_sizing.dart';

class AppTheme {
  static ThemeData lightTheme(double fontSizeScale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: TextTheme(
        displayLarge:
            AppTypography.displayLarge.apply(fontSizeFactor: fontSizeScale),
        displayMedium:
            AppTypography.displayMedium.apply(fontSizeFactor: fontSizeScale),
        displaySmall:
            AppTypography.displaySmall.apply(fontSizeFactor: fontSizeScale),
        headlineLarge:
            AppTypography.headlineLarge.apply(fontSizeFactor: fontSizeScale),
        headlineMedium:
            AppTypography.headlineMedium.apply(fontSizeFactor: fontSizeScale),
        headlineSmall:
            AppTypography.headlineSmall.apply(fontSizeFactor: fontSizeScale),
        titleLarge:
            AppTypography.titleLarge.apply(fontSizeFactor: fontSizeScale),
        titleMedium:
            AppTypography.titleMedium.apply(fontSizeFactor: fontSizeScale),
        titleSmall:
            AppTypography.titleSmall.apply(fontSizeFactor: fontSizeScale),
        bodyLarge: AppTypography.bodyLarge.apply(fontSizeFactor: fontSizeScale),
        bodyMedium:
            AppTypography.bodyMedium.apply(fontSizeFactor: fontSizeScale),
        bodySmall: AppTypography.bodySmall.apply(fontSizeFactor: fontSizeScale),
        labelLarge:
            AppTypography.labelLarge.apply(fontSizeFactor: fontSizeScale),
        labelMedium:
            AppTypography.labelMedium.apply(fontSizeFactor: fontSizeScale),
        labelSmall:
            AppTypography.labelSmall.apply(fontSizeFactor: fontSizeScale),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppSizing.borderThin,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: AppSizing.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle:
              AppTypography.labelLarge.apply(fontSizeFactor: fontSizeScale),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.large,
            vertical: AppSizing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(
              color: AppColors.primary, width: AppSizing.borderMedium),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizing.medium,
          vertical: AppSizing.small,
        ),
      ),
    );
  }

  static ThemeData darkTheme(double fontSizeScale) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.onSurfaceDark,
        onError: AppColors.onErrorDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: AppTypography.fontFamily,
      textTheme: TextTheme(
        displayLarge:
            AppTypography.displayLarge.apply(fontSizeFactor: fontSizeScale),
        displayMedium:
            AppTypography.displayMedium.apply(fontSizeFactor: fontSizeScale),
        displaySmall:
            AppTypography.displaySmall.apply(fontSizeFactor: fontSizeScale),
        headlineLarge:
            AppTypography.headlineLarge.apply(fontSizeFactor: fontSizeScale),
        headlineMedium:
            AppTypography.headlineMedium.apply(fontSizeFactor: fontSizeScale),
        headlineSmall:
            AppTypography.headlineSmall.apply(fontSizeFactor: fontSizeScale),
        titleLarge:
            AppTypography.titleLarge.apply(fontSizeFactor: fontSizeScale),
        titleMedium:
            AppTypography.titleMedium.apply(fontSizeFactor: fontSizeScale),
        titleSmall:
            AppTypography.titleSmall.apply(fontSizeFactor: fontSizeScale),
        bodyLarge: AppTypography.bodyLarge.apply(fontSizeFactor: fontSizeScale),
        bodyMedium:
            AppTypography.bodyMedium.apply(fontSizeFactor: fontSizeScale),
        bodySmall: AppTypography.bodySmall.apply(fontSizeFactor: fontSizeScale),
        labelLarge:
            AppTypography.labelLarge.apply(fontSizeFactor: fontSizeScale),
        labelMedium:
            AppTypography.labelMedium.apply(fontSizeFactor: fontSizeScale),
        labelSmall:
            AppTypography.labelSmall.apply(fontSizeFactor: fontSizeScale),
      ).apply(
        bodyColor: AppColors.onSurfaceDark,
        displayColor: AppColors.onSurfaceDark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: AppSizing.borderThin,
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: AppSizing.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle:
              AppTypography.labelLarge.apply(fontSizeFactor: fontSizeScale),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizing.large,
            vertical: AppSizing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(
              color: AppColors.primary, width: AppSizing.borderMedium),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizing.medium,
          vertical: AppSizing.small,
        ),
      ),
    );
  }
}
