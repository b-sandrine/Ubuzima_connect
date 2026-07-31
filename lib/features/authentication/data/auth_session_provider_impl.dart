import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/routing/auth_session.dart' as routing;
import '../domain/entities/user_role.dart' as auth;
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/role_selection_repository.dart';
import 'datasources/local/role_selection_local_data_source.dart';

/// Bridges Firebase Auth + Firestore profile into the routing-facing
/// [routing.AuthSessionProvider] contract.
///
/// Role resolution order:
/// 1. Hint from the sign-in result (when present)
/// 2. On-device AUTH-05 choice (sync — avoids a post-login spinner trap)
/// 3. Firestore `users/{uid}.role` (source of truth, async refresh)
@LazySingleton(as: routing.AuthSessionProvider)
class FirebaseAuthSessionProvider implements routing.AuthSessionProvider {
  final AuthRepository _authRepository;
  final RoleSelectionRepository _roleSelectionRepository;
  final RoleSelectionLocalDataSource _roleSelectionLocalDataSource;

  final _statusController =
      StreamController<routing.AuthSessionStatus>.broadcast();
  routing.AuthSessionStatus _status = routing.AuthSessionStatus.unknown;
  routing.UserRole _role = routing.UserRole.unknown;

  FirebaseAuthSessionProvider(
    this._authRepository,
    this._roleSelectionRepository,
    this._roleSelectionLocalDataSource,
  ) {
    _applyUser(_authRepository.currentUser != null);
    _authRepository.authStateChanges.listen((user) {
      _applyUser(user != null, uid: user?.id, roleHint: user?.role);
    });
  }

  void _applyUser(bool signedIn, {String? uid, String? roleHint}) {
    _status = signedIn
        ? routing.AuthSessionStatus.authenticated
        : routing.AuthSessionStatus.unauthenticated;
    if (signedIn) {
      _role = _resolveRoleSync(roleHint);
      unawaited(_refreshRole(uid: uid));
    } else {
      _role = routing.UserRole.unknown;
    }
    _statusController.add(_status);
  }

  /// Immediate role so route guards don't bounce to `/home` before Firestore
  /// responds. Prefers a real hint, then the onboarding choice on disk.
  routing.UserRole _resolveRoleSync(String? roleHint) {
    final fromHint = _mapStorageRole(roleHint);
    if (fromHint != routing.UserRole.unknown) {
      return fromHint;
    }
    return _mapStorageRole(_roleSelectionLocalDataSource.readSelectedRole());
  }

  Future<void> _refreshRole({String? uid}) async {
    final userId = uid ?? _authRepository.currentUser?.id;

    if (userId != null) {
      final remote = await _authRepository.fetchUserRole(userId);
      final remoteRole = remote.fold((_) => null, (role) => role);
      final mapped = _mapStorageRole(remoteRole);
      if (mapped != routing.UserRole.unknown) {
        _role = mapped;
        _statusController.add(_status);
        return;
      }
    }

    final local = await _roleSelectionRepository.getSelectedRole();
    local.fold(
      (_) {/* keep current */},
      (role) {
        final mapped = _mapRole(role);
        if (mapped != routing.UserRole.unknown) {
          _role = mapped;
        }
      },
    );
    _statusController.add(_status);
  }

  routing.UserRole _mapStorageRole(String? value) {
    if (value == null || value.isEmpty || value == 'unknown') {
      return routing.UserRole.unknown;
    }
    return _mapRole(auth.UserRole.fromStorageValue(value));
  }

  routing.UserRole _mapRole(auth.UserRole? role) => switch (role) {
        auth.UserRole.patient => routing.UserRole.patient,
        auth.UserRole.communityHealthWorker =>
          routing.UserRole.communityHealthWorker,
        auth.UserRole.doctor => routing.UserRole.doctor,
        null => routing.UserRole.unknown,
      };

  @override
  routing.AuthSessionStatus get currentStatus => _status;

  @override
  routing.UserRole get currentRole => _role;

  @override
  String? get currentUserId => _authRepository.currentUser?.id;

  @override
  String? get currentDisplayName => _authRepository.currentUser?.displayName;

  @override
  Stream<routing.AuthSessionStatus> get statusStream =>
      _statusController.stream;
}
