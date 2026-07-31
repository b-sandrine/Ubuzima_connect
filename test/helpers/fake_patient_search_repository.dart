import 'package:ubuzima_connect/core/theme/app_colors.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/ai_insight.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/dashboard_stat.dart';
import 'package:ubuzima_connect/features/doctors/domain/models/patient_record.dart';
import 'package:ubuzima_connect/features/doctors/domain/repositories/patient_search_repository.dart';

/// Deterministic [PatientSearchRepository] fixture for widget tests — no
/// Firestore, no AI call, just fixed data the tests assert against.
class FakePatientSearchRepository implements PatientSearchRepository {
  const FakePatientSearchRepository();

  @override
  Future<List<DashboardStat>> getPatientStats() async => const [
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

  @override
  Future<AiInsight> getFollowUpInsight() async => const AiInsight(
    title: 'AI Alert',
    timestampLabel: 'Just now',
    message: 'AI Alert: Test follow-up reminder.',
  );

  @override
  Future<List<PatientRecord>> getRecentPatients() async => const [
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
  ];
}
