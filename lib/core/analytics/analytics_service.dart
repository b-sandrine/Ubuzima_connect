import 'package:injectable/injectable.dart';

import '../logging/app_logger.dart';

/// Event-tracking abstraction so screens/Blocs log events without knowing
/// the analytics provider. Swap [NoOpAnalyticsService] for a Firebase
/// Analytics-backed implementation once analytics requirements are defined
/// — kept as a no-op at foundation stage rather than pulling in an
/// unconfigured provider.
abstract interface class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
}

@LazySingleton(as: AnalyticsService)
class NoOpAnalyticsService implements AnalyticsService {
  final AppLogger _logger;

  NoOpAnalyticsService(this._logger);

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    _logger.debug('analytics event: $name $parameters');
  }

  @override
  Future<void> setUserId(String? userId) async {
    _logger.debug('analytics setUserId: $userId');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    _logger.debug('analytics setUserProperty: $name=$value');
  }
}
