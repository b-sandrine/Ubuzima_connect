import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';

/// Reads the CHW patient health record (CHW health record screen).
abstract interface class HealthRecordRepository {
  Future<Either<Failure, HealthRecord>> getHealthRecord();
}
