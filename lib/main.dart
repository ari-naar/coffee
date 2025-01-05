import 'package:coffee_app/screens/auth_screen.dart';
import 'package:coffee_app/screens/profile_screen.dart';
import 'package:coffee_app/screens/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'services/service_locator.dart';
import 'themes/app_theme.dart';
import 'providers/coffee_shops_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase - it will use platform-specific config files
  await Firebase.initializeApp();

  // Initialize services
  await serviceLocator.initialize();

  runApp(const CoffeeTrackApp());
}

class CoffeeTrackApp extends StatelessWidget {
  const CoffeeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CoffeeShopsProvider(),
        ),
      ],
      child: ScreenUtilInit(
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
                    home: const ScaffoldScreen(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
