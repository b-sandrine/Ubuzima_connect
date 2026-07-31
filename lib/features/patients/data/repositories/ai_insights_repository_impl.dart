import 'package:injectable/injectable.dart';

import '../../domain/models/ai_health_summary.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/guidance_tip.dart';
import '../../domain/models/health_overview.dart';
import '../../domain/models/recent_insight.dart';
import '../../domain/models/risk_signal.dart';
import '../../domain/models/vital_reading.dart';
import '../../domain/repositories/ai_insights_repository.dart';
import '../datasources/remote/ai_insights_remote_data_source.dart';

@LazySingleton(as: AiInsightsRepository)
class AiInsightsRepositoryImpl implements AiInsightsRepository {
  final AiInsightsRemoteDataSource _remoteDataSource;

  const AiInsightsRepositoryImpl(this._remoteDataSource);

  @override
  Future<HealthOverview> getHealthOverview() =>
      _remoteDataSource.readHealthOverview();

  @override
  Future<List<VitalReading>> getHealthSummaryMetrics() =>
      _remoteDataSource.readHealthSummaryMetrics();

  @override
  Future<List<BpTrendPoint>> getBpTrend() => _remoteDataSource.readBpTrend();

  @override
  Future<List<RiskSignal>> getRiskSignals() =>
      _remoteDataSource.readRiskSignals();

  @override
  Future<List<GuidanceTip>> getGuidanceTips() =>
      _remoteDataSource.readGuidanceTips();

  @override
  Future<AiHealthSummary> getAiHealthSummary() =>
      _remoteDataSource.readAiHealthSummary();

  @override
  Future<List<RecentInsight>> getRecentInsights() =>
      _remoteDataSource.readRecentInsights();
}
