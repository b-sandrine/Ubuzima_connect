import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/patient_timeline.dart';

/// Contract for DOC-04's data. Backed by a local mock today; filtering and
/// search happen in the Bloc over the full list, so this only needs to load
/// the timeline once.
abstract interface class TimelineRepository {
  Future<Either<Failure, PatientTimeline>> getTimeline();
}
