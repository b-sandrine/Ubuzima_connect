import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_board.dart';
import '../../domain/entities/referral_draft.dart';
import '../../domain/repositories/referral_repository.dart';
import '../datasources/remote/referral_remote_data_source.dart';

@LazySingleton(as: ReferralRepository)
class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralRemoteDataSource _remoteDataSource;

  const ReferralRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReferralBoard>> getBoard() =>
      _guard(() => _remoteDataSource.readBoard());

  @override
  Future<Either<Failure, ReferralBoard>> acceptReferral(
    String reference, {
    String? routedSpecialty,
  }) => _guard(
    () => _remoteDataSource.setStatus(
      reference,
      ReferralStatus.accepted,
      routedSpecialty: routedSpecialty,
    ),
  );

  @override
  Future<Either<Failure, ReferralBoard>> declineReferral(String reference) =>
      _guard(
        () => _remoteDataSource.setStatus(reference, ReferralStatus.declined),
      );

  @override
  Future<Either<Failure, ReferralBoard>> deleteReferral(String reference) =>
      _guard(() => _remoteDataSource.deleteReferral(reference));

  @override
  Future<Either<Failure, String>> createReferral(ReferralDraft draft) async {
    if (!draft.isComplete) {
      return const Left(
        ValidationFailure('Please complete the required referral fields.'),
      );
    }
    try {
      return Right(await _remoteDataSource.addReferral(draft));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, ReferralBoard>> _guard(
    Future<ReferralBoard> Function() action,
  ) async {
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
