import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/patient_timeline.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../datasources/local/timeline_local_data_source.dart';

@LazySingleton(as: TimelineRepository)
class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineLocalDataSource _localDataSource;

  const TimelineRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, PatientTimeline>> getTimeline() async {
    try {
      return Right(_localDataSource.readTimeline());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
