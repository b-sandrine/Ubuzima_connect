import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_board.dart';
import '../repositories/referral_repository.dart';

@injectable
class DeleteReferral {
  final ReferralRepository _repository;

  const DeleteReferral(this._repository);

  Future<Either<Failure, ReferralBoard>> call(String reference) =>
      _repository.deleteReferral(reference);
}
