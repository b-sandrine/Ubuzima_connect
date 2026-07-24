import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_board.dart';
import '../repositories/referral_repository.dart';

@injectable
class DeclineReferral {
  final ReferralRepository _repository;

  const DeclineReferral(this._repository);

  Future<Either<Failure, ReferralBoard>> call(String reference) =>
      _repository.declineReferral(reference);
}
