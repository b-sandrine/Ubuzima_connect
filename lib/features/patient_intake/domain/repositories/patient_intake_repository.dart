import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/patient_intake_draft.dart';
import '../entities/registered_patient.dart';

abstract interface class PatientIntakeRepository {
  /// Persists a completed registration draft and returns the new patient's
  /// record id.
  Future<Either<Failure, String>> submitPatientIntake(
    PatientIntakeDraft draft,
  );

  /// Loads patients created via intake, newest first.
  Future<Either<Failure, List<RegisteredPatient>>> listRegisteredPatients({
    bool forCurrentUserOnly = false,
  });
}
