import 'theme_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ThemeService theme;

  Future<void> initialize() async {
    theme = ThemeService();
    await theme.initialize();
  }

  void dispose() {
    theme.dispose();
  }
}

final serviceLocator = ServiceLocator();
