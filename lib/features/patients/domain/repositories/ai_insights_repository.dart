import '../models/ai_health_summary.dart';
import '../models/bp_trend_point.dart';
import '../models/guidance_tip.dart';
import '../models/health_overview.dart';
import '../models/recent_insight.dart';
import '../models/risk_signal.dart';
import '../models/vital_reading.dart';

/// The data contract the AI Insights screen is built against.
///
/// [AiInsightsRepositoryImpl] fulfills it with a Firestore-backed data
/// source, seeded once from [AiInsightsLocalDataSource] on first read.
abstract class AiInsightsRepository {
  Future<HealthOverview> getHealthOverview();

  Future<List<VitalReading>> getHealthSummaryMetrics();

  Future<List<BpTrendPoint>> getBpTrend();

  Future<List<RiskSignal>> getRiskSignals();

  Future<List<GuidanceTip>> getGuidanceTips();

  Future<AiHealthSummary> getAiHealthSummary();

  Future<List<RecentInsight>> getRecentInsights();
}
