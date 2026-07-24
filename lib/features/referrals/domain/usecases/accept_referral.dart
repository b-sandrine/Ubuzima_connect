import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_board.dart';
import '../repositories/referral_repository.dart';

@injectable
class AcceptReferral {
  final ReferralRepository _repository;

  const AcceptReferral(this._repository);

  Future<Either<Failure, ReferralBoard>> call(
    String reference, {
    String? routedSpecialty,
  }) =>
      _repository.acceptReferral(reference, routedSpecialty: routedSpecialty);
}
