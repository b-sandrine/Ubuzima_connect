import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';
import '../repositories/health_record_repository.dart';

@injectable
class CompleteNextStep {
  final HealthRecordRepository _repository;

  const CompleteNextStep(this._repository);

  Future<Either<Failure, HealthRecord>> call(
    String stepId, {
    String? patientId,
  }) => _repository.completeNextStep(stepId, patientId: patientId);
}
