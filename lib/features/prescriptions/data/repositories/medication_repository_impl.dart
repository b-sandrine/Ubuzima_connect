import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/medication_schedule.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/local/medication_local_data_source.dart';

@LazySingleton(as: MedicationRepository)
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource _localDataSource;

  const MedicationRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, MedicationSchedule>> getTodaySchedule() async {
    try {
      return Right(_localDataSource.readTodaySchedule());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicationSchedule>> markDoseTaken(
    String doseId,
  ) async {
    try {
      return Right(_localDataSource.markDoseTaken(doseId));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicationSchedule>> requestRefill() async {
    try {
      return Right(_localDataSource.requestRefill());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
