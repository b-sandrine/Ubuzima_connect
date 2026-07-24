import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_draft.dart';
import '../repositories/referral_repository.dart';

@injectable
class CreateReferral {
  final ReferralRepository _repository;

  const CreateReferral(this._repository);

  Future<Either<Failure, String>> call(ReferralDraft draft) =>
      _repository.createReferral(draft);
}
