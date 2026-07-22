import 'package:injectable/injectable.dart';

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

/// Foundation-stage placeholder so routing/DI compile and run before the
/// `authentication` feature exists. Remove the `@LazySingleton` annotation
/// here the moment `features/authentication` registers its own
/// [AuthSessionProvider] implementation — GetIt only allows one binding per
/// interface.
@LazySingleton(as: AuthSessionProvider)
class NoOpAuthSessionProvider implements AuthSessionProvider {
  @override
  AuthSessionStatus get currentStatus => AuthSessionStatus.unauthenticated;

  @override
  UserRole get currentRole => UserRole.unknown;

  @override
  Stream<AuthSessionStatus> get statusStream =>
      Stream.value(AuthSessionStatus.unauthenticated);
}
