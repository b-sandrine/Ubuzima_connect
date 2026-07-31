import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/backgrounds/app_gradient_background.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/navigation/app_top_bar.dart';
import '../../../../shared/widgets/navigation/segmented_tabs.dart';
import '../../../../core/di/injection.dart';
import '../../domain/models/ai_health_summary.dart';
import '../../domain/models/bp_trend_point.dart';
import '../../domain/models/guidance_tip.dart';
import '../../domain/models/health_overview.dart';
import '../../domain/models/recent_insight.dart';
import '../../domain/models/risk_signal.dart';
import '../../domain/models/vital_reading.dart';
import '../../domain/repositories/ai_insights_repository.dart';
import '../widgets/ai_bp_trend_card.dart';
import '../widgets/ai_health_summary_card.dart';
import '../widgets/ai_insights_hero_banner.dart';
import '../widgets/guidance_tip_card.dart';
import '../widgets/health_overview_card.dart';
import '../widgets/patient_bottom_navigation_bar.dart';
import '../widgets/recent_insight_row.dart';
import '../widgets/risk_signal_card.dart';
import '../widgets/vital_reading_card.dart';

enum _InsightsFilter { all, trends, riskSignals, guidance, vitals }

extension on _InsightsFilter {
  String get label => switch (this) {
    _InsightsFilter.all => 'All',
    _InsightsFilter.trends => 'Trends',
    _InsightsFilter.riskSignals => 'Risk Signals',
    _InsightsFilter.guidance => 'Guidance',
    _InsightsFilter.vitals => 'Vitals',
  };
}

/// The patient's AI Insights screen: health score overview, 30-day vitals
/// summary + trend, risk signals, personalized guidance, the full AI
/// analysis narrative, and recent insight history.
///
/// Data comes from an [AiInsightsRepository] — the Firestore-backed
/// implementation by default, resolved through DI so tests can still pass
/// a fake in directly.
class AiInsightsPage extends StatefulWidget {
  final AiInsightsRepository? repository;

  const AiInsightsPage({super.key, this.repository});

  @override
  State<AiInsightsPage> createState() => _AiInsightsPageState();
}

class _InsightsData {
  final HealthOverview overview;
  final List<VitalReading> summaryMetrics;
  final List<BpTrendPoint> bpTrend;
  final List<RiskSignal> riskSignals;
  final List<GuidanceTip> guidanceTips;
  final AiHealthSummary aiSummary;
  final List<RecentInsight> recentInsights;

  const _InsightsData({
    required this.overview,
    required this.summaryMetrics,
    required this.bpTrend,
    required this.riskSignals,
    required this.guidanceTips,
    required this.aiSummary,
    required this.recentInsights,
  });
}

class _AiInsightsPageState extends State<AiInsightsPage> {
  late Future<_InsightsData> _future;
  final int _navIndex = 2;
  _InsightsFilter _filter = _InsightsFilter.all;

  AiInsightsRepository get _repository =>
      widget.repository ?? getIt<AiInsightsRepository>();

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_InsightsData> _load() async {
    final results = await Future.wait([
      _repository.getHealthOverview(),
      _repository.getHealthSummaryMetrics(),
      _repository.getBpTrend(),
      _repository.getRiskSignals(),
      _repository.getGuidanceTips(),
      _repository.getAiHealthSummary(),
      _repository.getRecentInsights(),
    ]);

    return _InsightsData(
      overview: results[0] as HealthOverview,
      summaryMetrics: results[1] as List<VitalReading>,
      bpTrend: results[2] as List<BpTrendPoint>,
      riskSignals: results[3] as List<RiskSignal>,
      guidanceTips: results[4] as List<GuidanceTip>,
      aiSummary: results[5] as AiHealthSummary,
      recentInsights: results[6] as List<RecentInsight>,
    );
  }

  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.patientDashboard);
      case 1:
        context.go(AppRoutes.patientRecords);
      case 2:
        break;
      case 3:
        context.go(AppRoutes.patientNotifications);
      case 4:
        context.go(AppRoutes.patientSettings);
    }
  }

  void _printAction(String action) => debugPrint('Tapped: $action');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: FutureBuilder<_InsightsData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingIndicator(message: 'Loading insights…');
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Could not load AI insights. Please try again.',
                  onRetry: _refresh,
                );
              }

              final data = snapshot.requireData;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  children: [
                    const AppTopBar(
                      contextLabel: 'AI INSIGHTS',
                      contextIcon: LucideIcons.brain,
                      contextColor: Color(0xFF7C3AED),
                      trailing: [CircleIconButton(icon: LucideIcons.bell)],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const AiInsightsHeroBanner(
                      summary:
                          'Your health profile shows stable trends this '
                          'week. One risk signal detected for blood '
                          'pressure. 3 personalized guidance tips available.',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionTitle('Health Score'),
                    const SizedBox(height: AppSpacing.sm + 2),
                    HealthOverviewCard(overview: data.overview),
                    const SizedBox(height: AppSpacing.lg),
                    SegmentedTabs(
                      tabs: [for (final f in _InsightsFilter.values) f.label],
                      selectedIndex: _filter.index,
                      onSelected: (i) =>
                          setState(() => _filter = _InsightsFilter.values[i]),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_filter == _InsightsFilter.all ||
                        _filter == _InsightsFilter.vitals) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('Health Summaries'),
                          const Text(
                            'Last 30 days',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      _MetricsGrid(metrics: data.summaryMetrics),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    if (_filter == _InsightsFilter.all ||
                        _filter == _InsightsFilter.trends) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('Blood Pressure Trend'),
                          _PillLink(
                            label: '30 Days',
                            icon: LucideIcons.chartLine,
                            onTap: () => _printAction('BP Trend · 30 Days'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: AiBpTrendCard(points: data.bpTrend),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    if (_filter == _InsightsFilter.all ||
                        _filter == _InsightsFilter.riskSignals) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('Risk Signals'),
                          _PillLink(
                            label:
                                '${data.riskSignals.where((s) => s.level != RiskSignalLevel.low).length} Active',
                            color: AppColors.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      for (final signal in data.riskSignals) ...[
                        RiskSignalCard(signal: signal),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    if (_filter == _InsightsFilter.all ||
                        _filter == _InsightsFilter.guidance) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('Personalized Guidance'),
                          InkWell(
                            onTap: () =>
                                _printAction('Personalized Guidance · See All'),
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      for (final tip in data.guidanceTips) ...[
                        GuidanceTipCard(
                          tip: tip,
                          onCtaTap: () =>
                              _printAction('${tip.ctaLabel} · ${tip.title}'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                    ],
                    if (_filter == _InsightsFilter.all) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('AI Health Summary'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Generated Today',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      AiHealthSummaryCard(summary: data.aiSummary),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle('Recent Insights'),
                          InkWell(
                            onTap: () =>
                                _printAction('Recent Insights · View All'),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm + 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < data.recentInsights.length; i++)
                              RecentInsightRow(
                                insight: data.recentInsights[i],
                                showDivider:
                                    i != data.recentInsights.length - 1,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _ShareWithDoctorButton(
                        onTap: () =>
                            _printAction('Share Insights with Doctor'),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavigationBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _PillLink extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback? onTap;

  const _PillLink({
    required this.label,
    this.icon,
    this.color = AppColors.secondary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final List<VitalReading> metrics;

  const _MetricsGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < metrics.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: VitalReadingCard(reading: metrics[i])),
              if (i + 1 < metrics.length) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: VitalReadingCard(reading: metrics[i + 1])),
              ],
            ],
          ),
          if (i + 2 < metrics.length) const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ShareWithDoctorButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ShareWithDoctorButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x267C3AED),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.share2, size: 18, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Share Insights with Doctor',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
