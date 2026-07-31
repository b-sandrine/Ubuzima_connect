import 'package:injectable/injectable.dart';

import '../../domain/models/ai_health_insight.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/care_item.dart';
import '../../domain/models/health_score.dart';
import '../../domain/models/medication_reminder.dart';
import '../../domain/models/patient_profile.dart';
import '../../domain/models/quick_link.dart';
import '../../domain/models/vital_reading.dart';
import '../../domain/repositories/patient_dashboard_repository.dart';
import '../datasources/remote/patient_dashboard_remote_data_source.dart';

@LazySingleton(as: PatientDashboardRepository)
class PatientDashboardRepositoryImpl implements PatientDashboardRepository {
  final PatientDashboardRemoteDataSource _remoteDataSource;

  const PatientDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<PatientProfile> getCurrentPatient() => _remoteDataSource.readPatient();

  @override
  Future<HealthScore> getHealthScore() => _remoteDataSource.readHealthScore();

  @override
  Future<List<VitalReading>> getTodayVitals() =>
      _remoteDataSource.readTodayVitals();

  @override
  Future<List<MedicationReminder>> getMedicationReminders() =>
      _remoteDataSource.readMedicationReminders();

  @override
  Future<List<CareItem>> getUpcomingCare() =>
      _remoteDataSource.readUpcomingCare();

  @override
  Future<AiHealthInsight> getAiHealthInsight() =>
      _remoteDataSource.readAiHealthInsight();

  @override
  Future<List<QuickLink>> getQuickLinks() => _remoteDataSource.readQuickLinks();

  @override
  Future<List<BpTrendPoint>> getBpTrend() => _remoteDataSource.readBpTrend();
}
