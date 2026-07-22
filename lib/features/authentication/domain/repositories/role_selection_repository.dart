import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_role.dart';

/// Contract for persisting the role chosen on AUTH-05. The choice is made
/// before any account exists, so it lives on-device only — it is later read
/// back by the sign-up flow to stamp the role onto the new account.
abstract interface class RoleSelectionRepository {
  Future<Either<Failure, Unit>> saveSelectedRole(UserRole role);

  Future<Either<Failure, UserRole?>> getSelectedRole();
}
