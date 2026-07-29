import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/patient_intake_draft.dart';
import '../repositories/patient_intake_repository.dart';

@injectable
class SubmitPatientIntake {
  final PatientIntakeRepository _repository;

  const SubmitPatientIntake(this._repository);

  Future<Either<Failure, String>> call(PatientIntakeDraft draft) =>
      _repository.submitPatientIntake(draft);
}
