import '../../domain/models/consultation.dart';
import '../../domain/models/patient_record.dart';
import 'dummy_patient_search_data.dart';

/// Seeded data behind [MockConsultationRepository] — the same Marie Uwase
/// record used by Patient Search, now mid-visit with vitals already
/// recorded, matching the design.
abstract final class DummyConsultationData {
  static PatientRecord get patient => DummyPatientSearchData.recentPatients.first;

  static ConsultationSession session(DateTime now) => ConsultationSession(
    doctorName: 'Dr. Habimana',
    visitType: 'OPD',
    startedAt: now.subtract(const Duration(minutes: 2, seconds: 46)),
  );

  static const VitalsReading vitals = VitalsReading(
    systolicBp: 158,
    diastolicBp: 96,
    bloodGlucose: 14.2,
    pulseRate: 88,
    weightKg: 74.5,
    temperatureC: 36.8,
    spo2: 97,
  );

  static Consultation consultation(DateTime now) => Consultation(
    patient: patient,
    session: session(now),
    vitals: vitals,
  );
}
