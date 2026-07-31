import '../../domain/models/ai_health_summary.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/guidance_tip.dart';
import '../../domain/models/health_overview.dart';
import '../../domain/models/recent_insight.dart';
import '../../domain/models/risk_signal.dart';
import '../../domain/models/vital_reading.dart';
import '../../domain/repositories/ai_insights_repository.dart';
import '../dummy/dummy_ai_insights_data.dart';

/// Mock implementation of [AiInsightsRepository] used until the
/// Firestore-backed AI Insights screen is wired up. Every call goes through
/// `Future.delayed` to mimic a real network round trip.
class MockAiInsightsRepository implements AiInsightsRepository {
  const MockAiInsightsRepository();

  static const _simulatedLatency = Duration(milliseconds: 400);

  @override
  Future<HealthOverview> getHealthOverview() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.healthOverview,
    );
  }

  @override
  Future<List<VitalReading>> getHealthSummaryMetrics() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.healthSummaryMetrics,
    );
  }

  @override
  Future<List<BpTrendPoint>> getBpTrend() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.bpTrend30Days,
    );
  }

  @override
  Future<List<RiskSignal>> getRiskSignals() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.riskSignals,
    );
  }

  @override
  Future<List<GuidanceTip>> getGuidanceTips() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.guidanceTips,
    );
  }

  @override
  Future<AiHealthSummary> getAiHealthSummary() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.aiHealthSummary,
    );
  }

  @override
  Future<List<RecentInsight>> getRecentInsights() {
    return Future.delayed(
      _simulatedLatency,
      () => DummyAiInsightsData.recentInsights,
    );
  }
}
