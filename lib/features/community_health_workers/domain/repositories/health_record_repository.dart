import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';

/// Reads and mutates the CHW patient health record (CHW health record screen).
abstract interface class HealthRecordRepository {
  /// Loads the record for [patientId]. When null/empty, the demo CHW patient
  /// is used (showcase / offline demos).
  Future<Either<Failure, HealthRecord>> getHealthRecord({String? patientId});

  /// Marks a next step complete, removing it from the pending list.
  Future<Either<Failure, HealthRecord>> completeNextStep(
    String stepId, {
    String? patientId,
  });

  /// Forces a fresh AI risk assessment for the patient.
  Future<Either<Failure, HealthRecord>> regenerateAiAssessment({
    String? patientId,
  });
}
