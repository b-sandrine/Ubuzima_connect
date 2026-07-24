import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_board.dart';
import '../repositories/referral_repository.dart';

@injectable
class GetReferralBoard {
  final ReferralRepository _repository;

  const GetReferralBoard(this._repository);

  Future<Either<Failure, ReferralBoard>> call() => _repository.getBoard();
}
