import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// One logging facade for the whole app. Swapping the backend (e.g. wiring
/// Crashlytics/Sentry alongside console output) means touching this file
/// only, not every call site.
@lazySingleton
class AppLogger {
  final Logger _logger;

  AppLogger(this._logger);

  void debug(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  void info(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
