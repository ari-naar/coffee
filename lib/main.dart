import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/service_locator.dart';
import 'themes/app_colors.dart';
import 'themes/app_typography.dart';
import 'themes/app_sizing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
    ),
  );

  // Initialize services
  await serviceLocator.initialize();

  runApp(const CoffeeTrackApp());
}

class CoffeeTrackApp extends StatelessWidget {
  const CoffeeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: serviceLocator.theme.themeMode,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<double>(
          valueListenable: serviceLocator.theme.fontSizeScale,
          builder: (context, fontSizeScale, child) {
            return MaterialApp(
              title: 'CoffeeTrack',
              themeMode: themeMode,
              theme: _buildLightTheme(fontSizeScale),
              darkTheme: _buildDarkTheme(fontSizeScale),
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(
                  child: Text('Welcome to CoffeeTrack'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme(double fontSizeScale) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
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
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        margin: EdgeInsets.all(AppSizing.medium),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.all(AppSizing.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.large,
            vertical: AppSizing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.small),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.medium,
            vertical: AppSizing.small,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.onSurface,
        size: AppSizing.iconMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        labelStyle: AppTypography.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizing.medium,
          vertical: AppSizing.small,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          side: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme(double fontSizeScale) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),
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
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurfaceDark,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 2,
        margin: EdgeInsets.all(AppSizing.medium),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.all(AppSizing.medium),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.large,
            vertical: AppSizing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizing.small),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.medium,
            vertical: AppSizing.small,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.onSurfaceDark,
        size: AppSizing.iconMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceDark,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.onSurfaceDark,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizing.medium,
          vertical: AppSizing.small,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.small),
          side: BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }
}
