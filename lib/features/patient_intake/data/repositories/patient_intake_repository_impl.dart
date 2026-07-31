import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/patient_intake_draft.dart';
import '../../domain/entities/registered_patient.dart';
import '../../domain/repositories/patient_intake_repository.dart';
import '../datasources/remote/patient_intake_remote_data_source.dart';

@LazySingleton(as: PatientIntakeRepository)
class PatientIntakeRepositoryImpl implements PatientIntakeRepository {
  final PatientIntakeRemoteDataSource _remoteDataSource;

  const PatientIntakeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> submitPatientIntake(
    PatientIntakeDraft draft,
  ) async {
    try {
      return Right(await _remoteDataSource.submitPatientIntake(draft));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RegisteredPatient>>> listRegisteredPatients({
    bool forCurrentUserOnly = false,
  }) async {
    try {
      return Right(
        await _remoteDataSource.listRegisteredPatients(
          forCurrentUserOnly: forCurrentUserOnly,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
