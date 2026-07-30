import '../../domain/models/ai_insight.dart';
import '../../domain/models/allergy.dart';
import '../../domain/models/clinical_note.dart';
import '../../domain/models/clinical_summary_item.dart';
import '../../domain/models/patient_detail.dart';
import '../../domain/models/risk_indicator.dart';
import '../../domain/models/vital_sign.dart';
import '../../domain/repositories/patient_detail_repository.dart';
import '../dummy/dummy_patient_detail_data.dart';

/// Mock implementation of [PatientDetailRepository] used until the
/// Firestore-backed patient detail view is wired up. Every call goes
/// through `Future.delayed` to mimic a real network round trip.
class MockPatientDetailRepository implements PatientDetailRepository {
  const MockPatientDetailRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<PatientDetail> getPatientDetail() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.patient,
    );
  }

  @override
  Future<RiskProfile> getRiskProfile() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.riskProfile,
    );
  }

  @override
  Future<String> getAiAlertMessage() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.aiAlertMessage,
    );
  }

  @override
  Future<List<VitalSign>> getVitals() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.vitals,
    );
  }

  @override
  Future<String> getVitalsAsOfLabel() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.vitalsAsOfLabel,
    );
  }

  @override
  Future<List<Allergy>> getAllergies() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.allergies,
    );
  }

  @override
  Future<String> getDrugInteractionMessage() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.drugInteractionMessage,
    );
  }

  @override
  Future<List<ClinicalNote>> getClinicalNotes() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.clinicalNotes,
    );
  }

  @override
  Future<List<ClinicalSummaryItem>> getClinicalSummaryItems() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.clinicalSummaryItems,
    );
  }

  @override
  Future<AiInsight> getAiClinicalSummary() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyPatientDetailData.aiClinicalSummary,
    );
  }
}
