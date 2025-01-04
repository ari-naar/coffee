import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  bool _initialized = false;
  late final FirebaseOptions _firebaseOptions;

  /// Initialize the configuration service
  Future<void> init() async {
    if (_initialized) return;

    // Load environment variables
    await dotenv.load();

    // Initialize Firebase options
    _firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
    );

    // Initialize Firebase
    await Firebase.initializeApp(
      options: _firebaseOptions,
    );

    _initialized = true;
  }

  /// Get environment specific values
  String get apiUrl => dotenv.env['API_URL'] ?? 'https://api.coffeetrack.app';
  String get appName => dotenv.env['APP_NAME'] ?? 'CoffeeTrack';
  String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  /// Check if the app is running in development mode
  bool get isDevelopment => appEnv == 'development';

  /// Check if the app is running in production mode
  bool get isProduction => appEnv == 'production';

  /// Log configuration details in development mode
  void logConfig() {
    if (isDevelopment) {
      debugPrint('=== App Configuration ===');
      debugPrint('App Name: $appName');
      debugPrint('Environment: $appEnv');
      debugPrint('API URL: $apiUrl');
      debugPrint('Firebase Project ID: ${_firebaseOptions.projectId}');
      debugPrint('=====================');
    }
  }
}
