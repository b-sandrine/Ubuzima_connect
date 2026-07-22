/// App-wide literals that don't belong to any single feature.
abstract final class AppConstants {
  static const String appName = 'Ubuzima Connect';

  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheValidity = Duration(hours: 24);
  static const Duration syncRetryInterval = Duration(minutes: 5);
  static const int maxSyncRetries = 5;

  static const int defaultPageSize = 20;

  static const String defaultLocaleCode = 'en';
  static const List<String> supportedLocaleCodes = ['en', 'rw', 'fr'];
}
