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

  /// The signed-in Firebase user's uid, or null when unauthenticated.
  String? get currentUserId;

  /// The signed-in user's real display name (captured at registration), or
  /// null when unauthenticated or not set. UI that shows "who's logged in"
  /// should read this instead of falling back to seeded/demo data.
  String? get currentDisplayName;

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
  String? get currentUserId => null;

  @override
  String? get currentDisplayName => null;

  @override
  Stream<AuthSessionStatus> get statusStream =>
      Stream.value(AuthSessionStatus.unauthenticated);
}
