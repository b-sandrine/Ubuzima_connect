import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/patient_timeline.dart';
import '../../domain/repositories/timeline_repository.dart';
import '../datasources/remote/timeline_remote_data_source.dart';

@LazySingleton(as: TimelineRepository)
class TimelineRepositoryImpl implements TimelineRepository {
  final TimelineRemoteDataSource _remoteDataSource;

  const TimelineRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PatientTimeline>> getTimeline() async {
    try {
      return Right(await _remoteDataSource.readTimeline());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
