import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../core/routing/auth_session.dart' as routing;
import '../domain/entities/user_role.dart' as auth;
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/role_selection_repository.dart';

/// Bridges Firebase Auth into the routing-facing [routing.AuthSessionProvider]
/// contract. Role comes from the on-device choice saved on AUTH-05 until the
/// Firestore user profile is wired up.
@LazySingleton(as: routing.AuthSessionProvider)
class FirebaseAuthSessionProvider implements routing.AuthSessionProvider {
  final AuthRepository _authRepository;
  final RoleSelectionRepository _roleSelectionRepository;

  final _statusController =
      StreamController<routing.AuthSessionStatus>.broadcast();
  routing.AuthSessionStatus _status = routing.AuthSessionStatus.unknown;
  routing.UserRole _role = routing.UserRole.unknown;

  FirebaseAuthSessionProvider(
    this._authRepository,
    this._roleSelectionRepository,
  ) {
    _applyUser(_authRepository.currentUser != null);
    _authRepository.authStateChanges.listen((user) {
      _applyUser(user != null);
    });
  }

  void _applyUser(bool signedIn) {
    _status = signedIn
        ? routing.AuthSessionStatus.authenticated
        : routing.AuthSessionStatus.unauthenticated;
    if (signedIn) {
      unawaited(_refreshRole());
    } else {
      _role = routing.UserRole.unknown;
    }
    _statusController.add(_status);
  }

  Future<void> _refreshRole() async {
    final result = await _roleSelectionRepository.getSelectedRole();
    result.fold(
      (_) => _role = routing.UserRole.unknown,
      (role) => _role = _mapRole(role),
    );
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
  Stream<routing.AuthSessionStatus> get statusStream =>
      _statusController.stream;
}
