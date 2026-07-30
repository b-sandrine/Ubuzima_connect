import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ai_insight.dart';
import '../../domain/models/dashboard_stat.dart';
import '../../domain/models/patient_record.dart';

/// Seeded data behind [MockPatientSearchRepository]. Kept in its own file so
/// swapping in a Firestore-backed repository later is a data-source change
/// only — nothing in `presentation/` has to move.
abstract final class DummyPatientSearchData {
  static const List<DashboardStat> patientStats = [
    DashboardStat(
      id: 'stat-total',
      label: 'Total Patients',
      value: 247,
      color: AppColors.primary,
    ),
    DashboardStat(
      id: 'stat-seen-today',
      label: 'Seen Today',
      value: 14,
      color: AppColors.secondary,
    ),
    DashboardStat(
      id: 'stat-critical',
      label: 'Critical',
      value: 3,
      color: AppColors.danger,
    ),
  ];

  static const AiInsight followUpInsight = AiInsight(
    title: 'Follow-up Reminder',
    timestampLabel: 'Just now',
    message: '5 patients overdue for follow-up this week. Tap to review.',
  );

  static const List<PatientRecord> recentPatients = [
    PatientRecord(
      id: 'patient-001',
      name: 'Marie Uwase',
      patientCode: 'RW-2847',
      gender: 'F',
      age: 52,
      location: 'Ward 3B',
      status: PatientRecordStatus.critical,
      tags: ['Hypertension', 'Diabetes', 'CKD'],
      lastActivityLabel: 'Just now',
    ),
    PatientRecord(
      id: 'patient-002',
      name: 'Jean Mugisha',
      patientCode: 'RW-1193',
      gender: 'M',
      age: 47,
      location: 'Outpatient',
      status: PatientRecordStatus.urgent,
      tags: ['HbA1c High', 'Cardiology'],
      lastActivityLabel: '2h ago',
    ),
    PatientRecord(
      id: 'patient-003',
      name: 'Amina Kalisa',
      patientCode: 'RW-0584',
      gender: 'F',
      age: 34,
      location: 'OPD',
      status: PatientRecordStatus.stable,
      tags: ['Diabetes', 'Follow-up'],
      lastActivityLabel: '3h ago',
    ),
    PatientRecord(
      id: 'patient-004',
      name: 'Patrick Nkurunziza',
      patientCode: 'RW-3301',
      gender: 'M',
      age: 61,
      location: 'OPD',
      status: PatientRecordStatus.scheduled,
      tags: ['Hypertension'],
      lastActivityLabel: 'Yesterday',
    ),
    PatientRecord(
      id: 'patient-005',
      name: 'Claudine Mukamana',
      patientCode: 'RW-2105',
      gender: 'F',
      age: 28,
      location: 'Maternity',
      status: PatientRecordStatus.stable,
      tags: ['Antenatal', 'Week 32'],
      lastActivityLabel: 'Yesterday',
    ),
    PatientRecord(
      id: 'patient-006',
      name: 'Emmanuel Ndayisaba',
      patientCode: 'RW-4456',
      gender: 'M',
      age: 39,
      location: 'OPD',
      status: PatientRecordStatus.routine,
      tags: ['Fever', 'Malaria Screen'],
      lastActivityLabel: '2 days ago',
    ),
  ];
}
