import 'package:coffee_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  runApp(const CoffeeTrackApp());
}

class CoffeeTrackApp extends StatelessWidget {
  const CoffeeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(402, 874),
        builder: (context, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'CoffeeTrack',
                themeMode: themeProvider.themeMode,
                theme: AppTheme.lightTheme(themeProvider.fontSizeScale),
                darkTheme: AppTheme.darkTheme(themeProvider.fontSizeScale),
                debugShowCheckedModeBanner: false,
                home: const HomeScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
