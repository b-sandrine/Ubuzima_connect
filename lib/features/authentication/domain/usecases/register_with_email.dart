import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterWithEmail {
  final AuthRepository _repository;

  const RegisterWithEmail(this._repository);

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) =>
      _repository.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
}
