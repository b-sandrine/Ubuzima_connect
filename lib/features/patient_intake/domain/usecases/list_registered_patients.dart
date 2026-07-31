import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/registered_patient.dart';
import '../repositories/patient_intake_repository.dart';

/// Loads patients previously written by [SubmitPatientIntake].
@injectable
class ListRegisteredPatients {
  final PatientIntakeRepository _repository;

  const ListRegisteredPatients(this._repository);

  Future<Either<Failure, List<RegisteredPatient>>> call({
    bool forCurrentUserOnly = false,
  }) => _repository.listRegisteredPatients(
    forCurrentUserOnly: forCurrentUserOnly,
  );
}
