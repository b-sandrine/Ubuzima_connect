import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_role.dart';
import '../repositories/role_selection_repository.dart';

@injectable
class SaveSelectedRole {
  final RoleSelectionRepository _repository;

  const SaveSelectedRole(this._repository);

  Future<Either<Failure, Unit>> call(UserRole role) =>
      _repository.saveSelectedRole(role);
}
