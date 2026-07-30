import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/local/onboarding_local_data_source.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  const OnboardingRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> isOnboardingComplete() async {
    try {
      return Right(_localDataSource.readOnboardingComplete());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeOnboarding() async {
    try {
      await _localDataSource.cacheOnboardingComplete();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
