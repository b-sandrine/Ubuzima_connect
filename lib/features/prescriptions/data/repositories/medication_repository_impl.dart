import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/medication_schedule.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/remote/medication_remote_data_source.dart';

@LazySingleton(as: MedicationRepository)
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource _remoteDataSource;

  const MedicationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, MedicationSchedule>> getTodaySchedule() =>
      _guard(() => _remoteDataSource.readTodaySchedule());

  @override
  Future<Either<Failure, MedicationSchedule>> markDoseTaken(String doseId) =>
      _guard(() => _remoteDataSource.markDoseTaken(doseId));

  @override
  Future<Either<Failure, MedicationSchedule>> requestRefill() =>
      _guard(() => _remoteDataSource.requestRefill());

  /// Runs a Firestore call and translates its throwables into typed failures
  /// at the data → domain boundary.
  Future<Either<Failure, MedicationSchedule>> _guard(
    Future<MedicationSchedule> Function() action,
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
