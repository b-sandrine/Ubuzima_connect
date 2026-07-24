import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/patient_timeline.dart';
import '../repositories/timeline_repository.dart';

@injectable
class GetPatientTimeline {
  final TimelineRepository _repository;

  const GetPatientTimeline(this._repository);

  Future<Either<Failure, PatientTimeline>> call() => _repository.getTimeline();
}
