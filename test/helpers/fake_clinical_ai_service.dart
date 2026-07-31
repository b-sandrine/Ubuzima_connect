import 'package:ubuzima_connect/core/ai/clinical_ai_service.dart';

/// Deterministic AI stub for widget/unit tests — never calls Gemini.
class FakeClinicalAiService implements ClinicalAiService {
  const FakeClinicalAiService();

  @override
  Future<String> generateDoctorPanelInsight({
    required String clinicalContext,
  }) async =>
      'Test panel insight for follow-up gaps.';

  @override
  Future<String> generateFollowUpInsight({
    required String clinicalContext,
  }) async =>
      'AI Alert: Test follow-up reminder.';

  @override
  Future<String> generatePatientClinicalSummary({
    required String clinicalContext,
  }) async =>
      'Test clinical summary for the patient chart.';

  @override
  Future<String> generatePatientAlert({
    required String clinicalContext,
  }) async =>
      'Test clinical alert banner.';

  @override
  Future<String> generatePatientHealthInsight({
    required String clinicalContext,
  }) async =>
      'Test patient health insight about recent vitals.';

  @override
  Future<String> generateTimelineAnalysis({
    required String clinicalContext,
  }) async =>
      'Test timeline analysis of disease progression.';

  @override
  Future<String> generateMedicationInsight({
    required String clinicalContext,
  }) async =>
      'Test medication adherence insight.';

  @override
  Future<GeneratedHealthAssessment> generateChwAssessment({
    required String clinicalContext,
  }) async =>
      const GeneratedHealthAssessment(
        riskScore: 62,
        riskLevel: 'moderate',
        summary: 'Test CHW assessment summary for pregnancy monitoring.',
        keyRiskFactor: 'Pregnancy + Swelling',
        recommendation: 'ANC Visit in 3d',
      );

  @override
  Future<String> generateChwDayBriefing({
    required String clinicalContext,
  }) async =>
      'Test CHW day briefing: prioritize emergency flags, then finish visits.';
}
