import '../models/ai_insight.dart';
import '../models/allergy.dart';
import '../models/clinical_note.dart';
import '../models/clinical_summary_item.dart';
import '../models/patient_detail.dart';
import '../models/risk_indicator.dart';
import '../models/vital_sign.dart';

/// The data contract the Patient Details screen is built against.
///
/// Fulfilled by `FirestorePatientDetailRepository` in production.
abstract class PatientDetailRepository {
  Future<PatientDetail> getPatientDetail();

  Future<RiskProfile> getRiskProfile();

  Future<String> getAiAlertMessage();

  Future<List<VitalSign>> getVitals();

  Future<String> getVitalsAsOfLabel();

  Future<List<Allergy>> getAllergies();

  Future<String> getDrugInteractionMessage();

  Future<List<ClinicalNote>> getClinicalNotes();

  Future<List<ClinicalSummaryItem>> getClinicalSummaryItems();

  Future<AiInsight> getAiClinicalSummary();
}
