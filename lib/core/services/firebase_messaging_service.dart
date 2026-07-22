import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../logging/app_logger.dart';

/// Thin wrapper around the Firebase Cloud Messaging SDK: token retrieval,
/// permission request, and the foreground-message stream. Deciding what a
/// notification *means* and how to route/display it belongs to
/// `features/notifications`, which depends on this service rather than on
/// `firebase_messaging` directly.
@lazySingleton
class FirebaseMessagingService {
  final FirebaseMessaging _messaging;
  final AppLogger _logger;

  FirebaseMessagingService(this._messaging, this._logger);

  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e, stackTrace) {
      _logger.error('Failed to get FCM token', e, stackTrace);
      return null;
    }
  }

  Future<NotificationSettings> requestPermission() =>
      _messaging.requestPermission();

  Stream<RemoteMessage> get onForegroundMessage => FirebaseMessaging.onMessage;

  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
}
