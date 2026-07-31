import '../models/consultation.dart';

/// The data contract the Consultation screen is built against.
///
/// Fulfilled by `FirestoreConsultationRepository` in production.
abstract class ConsultationRepository {
  /// The doctor's in-progress consultation. Operates on the same fixed
  /// demo patient as Patient Search / Timeline until a real patient-selection
  /// flow lands.
  Future<Consultation> getActiveConsultation();

  /// Fire-and-forget background persistence as the doctor types — mirrors
  /// the design's "Auto-saved" indicator on the Vitals Entry card.
  Future<void> saveVitalsDraft(VitalsReading vitals);

  /// Finalizes the consultation with the given vitals.
  Future<Consultation> completeConsultation(VitalsReading vitals);
}
