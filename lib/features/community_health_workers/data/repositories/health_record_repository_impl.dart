import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../datasources/remote/health_record_remote_data_source.dart';

@LazySingleton(as: HealthRecordRepository)
class HealthRecordRepositoryImpl implements HealthRecordRepository {
  final HealthRecordRemoteDataSource _remoteDataSource;

  const HealthRecordRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HealthRecord>> getHealthRecord({String? patientId}) =>
      _guard(() => _remoteDataSource.readHealthRecord(patientId: patientId));

  @override
  Future<Either<Failure, HealthRecord>> completeNextStep(
    String stepId, {
    String? patientId,
  }) => _guard(
    () => _remoteDataSource.completeNextStep(stepId, patientId: patientId),
  );

  @override
  Future<Either<Failure, HealthRecord>> regenerateAiAssessment({
    String? patientId,
  }) => _guard(
    () => _remoteDataSource.regenerateAiAssessment(patientId: patientId),
  );

  Future<Either<Failure, HealthRecord>> _guard(
    Future<HealthRecord> Function() action,
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
