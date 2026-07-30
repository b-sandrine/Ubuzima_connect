import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInWithGoogle {
  final AuthRepository _repository;

  const SignInWithGoogle(this._repository);

  Future<Either<Failure, AuthUser>> call() => _repository.signInWithGoogle();
}
