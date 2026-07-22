import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// Typed wrapper around `permission_handler` so call sites reason about
/// [AppPermissionStatus] instead of raw platform permission strings.
enum AppPermissionStatus { granted, denied, permanentlyDenied, restricted }

enum AppPermission { location, camera, notification, storage }

abstract interface class PermissionService {
  Future<AppPermissionStatus> check(AppPermission permission);
  Future<AppPermissionStatus> request(AppPermission permission);
  Future<bool> openSettings();
}

@LazySingleton(as: PermissionService)
class PermissionServiceImpl implements PermissionService {
  @override
  Future<AppPermissionStatus> check(AppPermission permission) async {
    final status = await _resolve(permission).status;
    return _map(status);
  }

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final status = await _resolve(permission).request();
    return _map(status);
  }

  @override
  Future<bool> openSettings() => openAppSettings();

  Permission _resolve(AppPermission permission) => switch (permission) {
    AppPermission.location => Permission.locationWhenInUse,
    AppPermission.camera => Permission.camera,
    AppPermission.notification => Permission.notification,
    AppPermission.storage => Permission.storage,
  };

  AppPermissionStatus _map(PermissionStatus status) => switch (status) {
    PermissionStatus.granted ||
    PermissionStatus.limited => AppPermissionStatus.granted,
    PermissionStatus.permanentlyDenied => AppPermissionStatus.permanentlyDenied,
    PermissionStatus.restricted => AppPermissionStatus.restricted,
    _ => AppPermissionStatus.denied,
  };
}
