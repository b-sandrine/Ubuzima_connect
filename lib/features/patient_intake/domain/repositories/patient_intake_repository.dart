import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/patient_intake_draft.dart';

abstract interface class PatientIntakeRepository {
  /// Persists a completed registration draft and returns the new patient's
  /// record id.
  Future<Either<Failure, String>> submitPatientIntake(
    PatientIntakeDraft draft,
  );
}
