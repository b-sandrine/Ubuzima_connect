import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/medication_schedule.dart';
import '../repositories/medication_repository.dart';

@injectable
class MarkDoseTaken {
  final MedicationRepository _repository;

  const MarkDoseTaken(this._repository);

  Future<Either<Failure, MedicationSchedule>> call(String doseId) =>
      _repository.markDoseTaken(doseId);
}
