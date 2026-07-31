import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';
import '../repositories/health_record_repository.dart';

/// Regenerates the AI health assessment for a CHW patient record.
@injectable
class RegenerateAiAssessment {
  final HealthRecordRepository _repository;

  const RegenerateAiAssessment(this._repository);

  Future<Either<Failure, HealthRecord>> call({String? patientId}) =>
      _repository.regenerateAiAssessment(patientId: patientId);
}
