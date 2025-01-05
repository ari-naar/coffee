import 'package:logger/logger.dart';

abstract class BaseService {
  final _logger = Logger();

  void logInfo(String message) {
    _logger.i(message);
  }

  void logError(String message, [dynamic error]) {
    _logger.e(message, error: error);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logDebug(String message) {
    _logger.d(message);
  }
}
