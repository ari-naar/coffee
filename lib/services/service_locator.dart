import 'auth_service.dart';
import 'coffee_service.dart';
import 'location_service.dart';
import 'storage_service.dart';
import 'theme_service.dart';
import 'user_service.dart';

class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Services
  late final AuthService _authService;
  late final UserService _userService;
  late final CoffeeService _coffeeService;
  late final StorageService _storageService;
  late final LocationService _locationService;
  late final ThemeService _themeService;

  // Initialize all services
  Future<void> initialize() async {
    _authService = AuthService();
    _userService = UserService();
    _coffeeService = CoffeeService();
    _storageService = StorageService();
    _locationService = LocationService();
    _themeService = ThemeService();

    // Initialize services that require async initialization
    await _themeService.initialize();
  }

  // Service getters
  AuthService get auth => _authService;
  UserService get user => _userService;
  CoffeeService get coffee => _coffeeService;
  StorageService get storage => _storageService;
  LocationService get location => _locationService;
  ThemeService get theme => _themeService;

  // Reset all services (useful for testing)
  void reset() {
    initialize();
  }
}

// Global instance for easy access
final serviceLocator = ServiceLocator();
