import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_board.dart';
import '../../domain/entities/referral_draft.dart';
import '../../domain/repositories/referral_repository.dart';
import '../datasources/local/referral_local_data_source.dart';

@LazySingleton(as: ReferralRepository)
class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralLocalDataSource _localDataSource;

  const ReferralRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, ReferralBoard>> getBoard() async {
    try {
      return Right(_localDataSource.readBoard());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReferralBoard>> acceptReferral(
    String reference, {
    String? routedSpecialty,
  }) async {
    try {
      return Right(
        _localDataSource.setStatus(reference, ReferralStatus.accepted),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReferralBoard>> declineReferral(
    String reference,
  ) async {
    try {
      return Right(
        _localDataSource.setStatus(reference, ReferralStatus.declined),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createReferral(ReferralDraft draft) async {
    if (!draft.isComplete) {
      return const Left(
        ValidationFailure('Please complete the required referral fields.'),
      );
    }
    try {
      return Right(_localDataSource.addReferral(draft));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
