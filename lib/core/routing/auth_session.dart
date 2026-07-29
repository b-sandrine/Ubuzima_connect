enum AuthSessionStatus { unknown, authenticated, unauthenticated }

enum UserRole { patient, communityHealthWorker, doctor, unknown }

/// The `authentication` feature owns the real session/role source of truth.
/// `core/routing` depends only on this interface — never on the
/// `authentication` feature directly — so route guarding stays inside the
/// architecture's dependency-inversion rules (core defines the contract,
/// a feature fulfills it).
abstract interface class AuthSessionProvider {
  AuthSessionStatus get currentStatus;

  UserRole get currentRole;

  Stream<AuthSessionStatus> get statusStream;
}

/// Kept for unit tests that don't want a Firebase-backed session. The live
/// binding lives in `features/authentication` as
/// `FirebaseAuthSessionProvider`.
class NoOpAuthSessionProvider implements AuthSessionProvider {
  @override
  AuthSessionStatus get currentStatus => AuthSessionStatus.unauthenticated;

  @override
  UserRole get currentRole => UserRole.unknown;

  @override
  Stream<AuthSessionStatus> get statusStream =>
      Stream.value(AuthSessionStatus.unauthenticated);
}
