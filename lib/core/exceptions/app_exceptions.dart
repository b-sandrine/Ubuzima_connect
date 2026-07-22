/// Low-level throwables raised by data sources (Firestore, sqflite,
/// SharedPreferences, platform channels). Repositories catch these at the
/// Data → Domain boundary and translate them into a `core/errors/Failure`
/// — a widget or Bloc should never see one of these directly.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'A server error occurred.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'A local storage error occurred.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed.']);
}

class SyncConflictException implements Exception {
  final String message;
  const SyncConflictException([this.message = 'A sync conflict occurred.']);
}

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission denied.']);
}
