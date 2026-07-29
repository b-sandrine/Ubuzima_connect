import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignOut {
  final AuthRepository _repository;

  const SignOut(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.signOut();
}
