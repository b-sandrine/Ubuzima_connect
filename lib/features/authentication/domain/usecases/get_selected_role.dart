import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_role.dart';
import '../repositories/role_selection_repository.dart';

@injectable
class GetSelectedRole {
  final RoleSelectionRepository _repository;

  const GetSelectedRole(this._repository);

  Future<Either<Failure, UserRole?>> call() => _repository.getSelectedRole();
}
