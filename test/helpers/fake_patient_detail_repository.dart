import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ubuzima_connect/core/theme/app_colors.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/ai_insight.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/allergy.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/clinical_note.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/clinical_summary_item.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/patient_detail.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/patient_record.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/risk_indicator.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/vital_sign.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/patient_detail_repository.dart';

/// Deterministic [PatientDetailRepository] fixture for widget tests — no
/// Firestore, no AI call, just fixed data the tests assert against.
class FakePatientDetailRepository implements PatientDetailRepository {
  const FakePatientDetailRepository();

  @override
  Future<PatientDetail> getPatientDetail() async => const PatientDetail(
    id: 'patient-001',
    name: 'Marie Uwase',
    patientCode: 'RW-2847',
    gender: 'Female',
    age: 52,
    dateOfBirth: '12 Mar 1972',
    location: 'Ward 3B',
    hospital: 'Kigali District Hospital',
    status: PatientRecordStatus.critical,
    tags: ['Hypertension', 'Diabetes T2', 'CKD Stage 2'],
  );

  @override
  Future<RiskProfile> getRiskProfile() async => const RiskProfile(
    overallLabel: 'High Risk',
    overallColor: AppColors.danger,
    indicators: [
      RiskIndicator(
        label: 'Cardiovascular',
        percentage: 78,
        icon: LucideIcons.heart,
        color: AppColors.danger,
      ),
      RiskIndicator(
        label: 'Renal Function',
        percentage: 62,
        icon: LucideIcons.droplet,
        color: AppColors.warning,
      ),
    ],
  );

  @override
  Future<String> getAiAlertMessage() async => 'Test clinical alert banner.';

  @override
  Future<List<VitalSign>> getVitals() async => const [
    VitalSign(
      label: 'Blood Pressure',
      value: '158/96',
      unit: '',
      icon: LucideIcons.heartPulse,
      status: VitalStatus.high,
      trend: VitalTrendDirection.up,
      trendText: '+14 from last',
    ),
    VitalSign(
      label: 'SpO2',
      value: '97',
      unit: '%',
      icon: LucideIcons.wind,
      status: VitalStatus.normal,
      trend: VitalTrendDirection.stable,
      trendText: 'Stable',
    ),
  ];

  @override
  Future<String> getVitalsAsOfLabel() async => 'Today, 08:42 AM';

  @override
  Future<List<Allergy>> getAllergies() async => const [
    Allergy(label: 'Penicillin', severity: AllergySeverity.severe),
  ];

  @override
  Future<String> getDrugInteractionMessage() async =>
      'Drug interaction flag: Metformin + Contrast dye — hold before imaging';

  @override
  Future<List<ClinicalNote>> getClinicalNotes() async => const [
    ClinicalNote(
      id: 'note-001',
      authorName: 'Dr. Habimana Eric',
      authorRole: 'Attending Physician',
      timeLabel: 'Today',
      note: 'BP critically elevated. Started Amlodipine 10mg OD.',
      tags: ['BP Management'],
    ),
    ClinicalNote(
      id: 'note-002',
      authorName: 'Dr. Habimana Eric',
      authorRole: 'Attending Physician',
      timeLabel: '3 days ago',
      note: 'Creatinine elevated — CKD progression confirmed.',
      tags: ['CKD'],
    ),
  ];

  @override
  Future<List<ClinicalSummaryItem>> getClinicalSummaryItems() async => const [
    ClinicalSummaryItem(
      icon: LucideIcons.pill,
      title: 'Current Medications',
      subtitle: '5 active prescriptions',
    ),
  ];

  @override
  Future<AiInsight> getAiClinicalSummary() async => const AiInsight(
    title: 'AI Clinical Summary',
    timestampLabel: 'Generated just now',
    message: 'Test clinical summary for the patient chart.',
  );
}
