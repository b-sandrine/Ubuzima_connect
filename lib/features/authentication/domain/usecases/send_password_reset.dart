import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

@injectable
class SendPasswordReset {
  final AuthRepository _repository;

  const SendPasswordReset(this._repository);

  Future<Either<Failure, Unit>> call({required String email}) =>
      _repository.sendPasswordReset(email: email);
}
