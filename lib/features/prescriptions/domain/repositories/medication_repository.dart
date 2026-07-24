import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/medication_schedule.dart';

/// Contract for PAT-03's data. Backed by a local mock for now; the same
/// interface will front Firestore + the offline cache once the medications
/// collection lands, so the Bloc never changes.
abstract interface class MedicationRepository {
  Future<Either<Failure, MedicationSchedule>> getTodaySchedule();

  /// Logs a dose as taken and returns the updated schedule (adherence and
  /// the taken-count move with it).
  Future<Either<Failure, MedicationSchedule>> markDoseTaken(String doseId);

  /// Requests a pharmacy refill for the medication in the reminder banner.
  Future<Either<Failure, MedicationSchedule>> requestRefill();
}
