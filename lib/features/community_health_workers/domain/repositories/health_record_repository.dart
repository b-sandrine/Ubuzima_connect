import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';

/// Reads and mutates the CHW patient health record (CHW health record screen).
abstract interface class HealthRecordRepository {
  Future<Either<Failure, HealthRecord>> getHealthRecord();

  /// Marks a next step complete, removing it from the pending list.
  Future<Either<Failure, HealthRecord>> completeNextStep(String stepId);
}
