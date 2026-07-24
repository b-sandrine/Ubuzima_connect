import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/medication_schedule.dart';
import '../repositories/medication_repository.dart';

@injectable
class RequestRefill {
  final MedicationRepository _repository;

  const RequestRefill(this._repository);

  Future<Either<Failure, MedicationSchedule>> call() =>
      _repository.requestRefill();
}
