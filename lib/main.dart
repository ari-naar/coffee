import 'package:coffee_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'services/service_locator.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize services
  await serviceLocator.initialize();

  runApp(const CoffeeTrackApp());
}

class CoffeeTrackApp extends StatelessWidget {
  const CoffeeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: serviceLocator.theme.themeMode,
          builder: (context, themeMode, child) {
            return ValueListenableBuilder<double>(
              valueListenable: serviceLocator.theme.fontSizeScale,
              builder: (context, fontSizeScale, child) {
                return MaterialApp(
                  title: 'CoffeeTrack',
                  themeMode: themeMode,
                  theme: AppTheme.lightTheme(fontSizeScale),
                  darkTheme: AppTheme.darkTheme(fontSizeScale),
                  debugShowCheckedModeBanner: false,
                  home: const HomeScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}
