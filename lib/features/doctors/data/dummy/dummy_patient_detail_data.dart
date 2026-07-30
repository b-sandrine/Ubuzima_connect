import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_insight.dart';
import '../../domain/models/allergy.dart';
import '../../domain/models/clinical_note.dart';
import '../../domain/models/clinical_summary_item.dart';
import '../../domain/models/patient_detail.dart';
import '../../domain/models/patient_record.dart';
import '../../domain/models/risk_indicator.dart';
import '../../domain/models/vital_sign.dart';

/// Seeded data behind [MockPatientDetailRepository] — Marie Uwase's record,
/// matching the Ward 3B critical alert and Patient Search entry she also
/// appears in. Kept in its own file so swapping in a Firestore-backed
/// repository later is a data-source change only.
abstract final class DummyPatientDetailData {
  static const PatientDetail patient = PatientDetail(
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

  static const RiskProfile riskProfile = RiskProfile(
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
      RiskIndicator(
        label: 'Metabolic Risk',
        percentage: 54,
        icon: LucideIcons.activity,
        color: AppColors.secondary,
      ),
    ],
  );

  static const String aiAlertMessage =
      'Elevated creatinine + BP spike suggests worsening CKD. Consider '
      'nephrology referral.';

  static const String vitalsAsOfLabel = 'Today, 08:42 AM';

  static const List<VitalSign> vitals = [
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
      label: 'Blood Glucose',
      value: '14.2',
      unit: 'mmol/L',
      icon: LucideIcons.droplet,
      status: VitalStatus.elevated,
      trend: VitalTrendDirection.up,
      trendText: '+2.1 from last',
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
    VitalSign(
      label: 'Temperature',
      value: '36.8',
      unit: '°C',
      icon: LucideIcons.thermometer,
      status: VitalStatus.normal,
      trend: VitalTrendDirection.stable,
      trendText: 'Stable',
    ),
    VitalSign(
      label: 'Weight · BMI 28.4',
      value: '74',
      unit: 'kg',
      icon: LucideIcons.scale,
    ),
    VitalSign(
      label: 'Heart Rate · Sinus',
      value: '94',
      unit: 'bpm',
      icon: LucideIcons.heart,
    ),
  ];

  static const List<Allergy> allergies = [
    Allergy(label: 'Penicillin', severity: AllergySeverity.severe),
    Allergy(label: 'NSAIDs', severity: AllergySeverity.moderate),
    Allergy(label: 'Sulfonamides', severity: AllergySeverity.mild),
  ];

  static const String drugInteractionMessage =
      'Drug interaction flag: Metformin + Contrast dye — hold before imaging';

  static const List<ClinicalNote> clinicalNotes = [
    ClinicalNote(
      id: 'note-001',
      authorName: 'Dr. Habimana Eric',
      authorRole: 'Attending Physician',
      timeLabel: 'Today',
      note:
          'BP critically elevated at 158/96 mmHg. Started Amlodipine 10mg '
          'OD. Ordered 24hr urine protein. Nephrology consult requested '
          'urgently.',
      tags: ['BP Management', 'Nephrology'],
    ),
    ClinicalNote(
      id: 'note-002',
      authorName: 'Dr. Niyonzima Paul',
      authorRole: 'Endocrinologist',
      timeLabel: 'Yesterday',
      note:
          'HbA1c returned at 9.2%. Adjusted Metformin to 1000mg BD. Added '
          'Sitagliptin 50mg. Patient counselled on dietary compliance.',
      tags: ['Diabetes Review', 'Medication'],
    ),
    ClinicalNote(
      id: 'note-003',
      authorName: 'Dr. Habimana Eric',
      authorRole: 'Attending Physician',
      timeLabel: '3 days ago',
      note:
          'Creatinine 168 µmol/L — CKD progression confirmed. GFR 44. '
          'Initiated low-protein diet plan and fluid monitoring.',
      tags: ['CKD', 'Diet Plan'],
    ),
  ];

  static const List<ClinicalSummaryItem> clinicalSummaryItems = [
    ClinicalSummaryItem(
      icon: LucideIcons.pill,
      title: 'Current Medications',
      subtitle: '5 active prescriptions',
    ),
    ClinicalSummaryItem(
      icon: LucideIcons.flaskConical,
      title: 'Lab Results',
      subtitle: 'Last 2 days ago · 2 abnormal',
    ),
    ClinicalSummaryItem(
      icon: LucideIcons.calendar,
      title: 'Follow-Up Plan',
      subtitle: 'Next: 5 Jun 2025 · Nephrology',
    ),
  ];

  static const AiInsight aiClinicalSummary = AiInsight(
    title: 'AI Clinical Summary',
    timestampLabel: 'Generated just now',
    message:
        'Marie presents with uncontrolled HTN and T2DM complicated by CKD '
        'Stage 2–3a progression. Priority: nephrology referral, renal-safe '
        'medication review, and strict BP target <130/80. HbA1c requires '
        'intensive glycemic management. Consider ACEi dose optimization '
        'with renal monitoring every 4 weeks.',
  );
}
