import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/health_record.dart';
import '../../domain/repositories/health_record_repository.dart';
import '../datasources/local/health_record_local_data_source.dart';

@LazySingleton(as: HealthRecordRepository)
class HealthRecordRepositoryImpl implements HealthRecordRepository {
  final HealthRecordLocalDataSource _localDataSource;

  const HealthRecordRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, HealthRecord>> getHealthRecord() async {
    try {
      return Right(_localDataSource.readHealthRecord());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
