import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/health_record.dart';
import '../repositories/health_record_repository.dart';

/// Loads the CHW patient health record in one call.
@injectable
class GetHealthRecord {
  final HealthRecordRepository _repository;

  const GetHealthRecord(this._repository);

  Future<Either<Failure, HealthRecord>> call() => _repository.getHealthRecord();
}
