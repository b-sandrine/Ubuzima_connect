import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/ai_health_summary.dart';
import '../../../domain/models/bp_trend_point.dart';
import '../../../domain/models/guidance_tip.dart';
import '../../../domain/models/health_overview.dart';
import '../../../domain/models/recent_insight.dart';
import '../../../domain/models/risk_signal.dart';
import '../../../domain/models/vital_reading.dart';
import '../local/ai_insights_local_data_source.dart';

/// Firestore-backed source for the AI Insights screen. Layout:
///
///   ai_insights/{patientId} → one document holding every section as a
///                             field/array — none of it is independently
///                             mutated by id today, so a single doc (no
///                             subcollections) keeps this simple.
///
/// Seeded from [AiInsightsLocalDataSource] on first read. Icon/colour for
/// summary metrics, risk signals, guidance tips and recent insights stay a
/// local cosmetic lookup by id — only the descriptive/numeric fields are
/// read from Firestore.
abstract interface class AiInsightsRemoteDataSource {
  Future<HealthOverview> readHealthOverview();

  Future<List<VitalReading>> readHealthSummaryMetrics();

  Future<List<BpTrendPoint>> readBpTrend();

  Future<List<RiskSignal>> readRiskSignals();

  Future<List<GuidanceTip>> readGuidanceTips();

  Future<AiHealthSummary> readAiHealthSummary();

  Future<List<RecentInsight>> readRecentInsights();
}

@LazySingleton(as: AiInsightsRemoteDataSource)
class AiInsightsRemoteDataSourceImpl implements AiInsightsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final AiInsightsLocalDataSource _seed;

  AiInsightsRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.aiInsights)
      .doc(AppConstants.demoPatientId);

  @override
  Future<HealthOverview> readHealthOverview() async {
    final data = await _readOrSeed();
    final overview =
        (data['healthOverview'] as Map?)?.cast<String, dynamic>() ?? {};
    return HealthOverview(
      score: (overview['score'] as num?)?.toInt() ?? 0,
      maxScore: (overview['maxScore'] as num?)?.toInt() ?? 100,
      statusLabel: overview['statusLabel'] as String? ?? '',
      trendLabel: overview['trendLabel'] as String? ?? '',
      signalsCount: (overview['signalsCount'] as num?)?.toInt() ?? 0,
      positiveCount: (overview['positiveCount'] as num?)?.toInt() ?? 0,
      watchCount: (overview['watchCount'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<List<VitalReading>> readHealthSummaryMetrics() async {
    final data = await _readOrSeed();
    final cosmeticsById = {
      for (final v in _seed.readHealthSummaryMetrics()) v.id: v,
    };

    return ((data['healthSummaryMetrics'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((v) {
          final id = v['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return VitalReading(
            id: id,
            label: cosmetics?.label ?? '',
            value: v['value'] as String? ?? '',
            subLabel: v['subLabel'] as String? ?? '',
            icon: cosmetics?.icon ?? LucideIcons.circle,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
            badgeLabel: v['badgeLabel'] as String? ?? '',
            badgeColor: cosmetics?.badgeColor ?? AppColors.textTertiary,
          );
        })
        .toList();
  }

  @override
  Future<List<BpTrendPoint>> readBpTrend() async {
    final data = await _readOrSeed();
    return ((data['bpTrend'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(
          (p) => BpTrendPoint(
            dayLabel: p['dayLabel'] as String? ?? '',
            systolic: (p['systolic'] as num?)?.toDouble() ?? 0,
            diastolic: (p['diastolic'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();
  }

  @override
  Future<List<RiskSignal>> readRiskSignals() async {
    final data = await _readOrSeed();
    final cosmeticsById = {for (final r in _seed.readRiskSignals()) r.id: r};

    return ((data['riskSignals'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((r) {
          final id = r['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return RiskSignal(
            id: id,
            icon: cosmetics?.icon ?? LucideIcons.circle,
            color: cosmetics?.color ?? AppColors.textTertiary,
            title: cosmetics?.title ?? '',
            levelLabel: r['levelLabel'] as String? ?? '',
            level: RiskSignalLevel.values.byName(
              r['level'] as String? ?? 'low',
            ),
            progress: (r['progress'] as num?)?.toDouble() ?? 0,
            description: r['description'] as String? ?? '',
          );
        })
        .toList();
  }

  @override
  Future<List<GuidanceTip>> readGuidanceTips() async {
    final data = await _readOrSeed();
    final cosmeticsById = {for (final g in _seed.readGuidanceTips()) g.id: g};

    return ((data['guidanceTips'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((g) {
          final id = g['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return GuidanceTip(
            id: id,
            icon: cosmetics?.icon ?? LucideIcons.circle,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
            title: g['title'] as String? ?? '',
            tagLabel: g['tagLabel'] as String? ?? '',
            tagColor: cosmetics?.tagColor ?? AppColors.textTertiary,
            description: g['description'] as String? ?? '',
            ctaLabel: cosmetics?.ctaLabel,
          );
        })
        .toList();
  }

  @override
  Future<AiHealthSummary> readAiHealthSummary() async {
    final data = await _readOrSeed();
    final summary =
        (data['aiHealthSummary'] as Map?)?.cast<String, dynamic>() ?? {};
    final cosmetics = _seed.readAiHealthSummary();

    return AiHealthSummary(
      patientName: summary['patientName'] as String? ?? '',
      dateLabel: summary['dateLabel'] as String? ?? '',
      body: summary['body'] as String? ?? '',
      tags: cosmetics.tags,
    );
  }

  @override
  Future<List<RecentInsight>> readRecentInsights() async {
    final data = await _readOrSeed();
    final cosmeticsById = {
      for (final r in _seed.readRecentInsights()) r.id: r,
    };

    return ((data['recentInsights'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((r) {
          final id = r['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return RecentInsight(
            id: id,
            icon: cosmetics?.icon ?? LucideIcons.circle,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
            title: r['title'] as String? ?? '',
            timestampLabel: r['timestampLabel'] as String? ?? '',
            description: r['description'] as String? ?? '',
          );
        })
        .toList();
  }

  Future<Map<String, dynamic>> _readOrSeed() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists) {
        await _seedFirestore();
        return (await _doc.get()).data() ?? const {};
      }
      return snapshot.data() ?? const {};
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load AI insights.');
    }
  }

  Future<void> _seedFirestore() async {
    final overview = _seed.readHealthOverview();
    final metrics = _seed.readHealthSummaryMetrics();
    final bpTrend = _seed.readBpTrend30Days();
    final riskSignals = _seed.readRiskSignals();
    final guidanceTips = _seed.readGuidanceTips();
    final aiSummary = _seed.readAiHealthSummary();
    final recentInsights = _seed.readRecentInsights();

    await _doc.set({
      'healthOverview': {
        'score': overview.score,
        'maxScore': overview.maxScore,
        'statusLabel': overview.statusLabel,
        'trendLabel': overview.trendLabel,
        'signalsCount': overview.signalsCount,
        'positiveCount': overview.positiveCount,
        'watchCount': overview.watchCount,
      },
      'healthSummaryMetrics': [
        for (final m in metrics)
          {
            'id': m.id,
            'value': m.value,
            'subLabel': m.subLabel,
            'badgeLabel': m.badgeLabel,
          },
      ],
      'bpTrend': [
        for (final p in bpTrend)
          {
            'dayLabel': p.dayLabel,
            'systolic': p.systolic,
            'diastolic': p.diastolic,
          },
      ],
      'riskSignals': [
        for (final r in riskSignals)
          {
            'id': r.id,
            'levelLabel': r.levelLabel,
            'level': r.level.name,
            'progress': r.progress,
            'description': r.description,
          },
      ],
      'guidanceTips': [
        for (final g in guidanceTips)
          {
            'id': g.id,
            'title': g.title,
            'tagLabel': g.tagLabel,
            'description': g.description,
          },
      ],
      'aiHealthSummary': {
        'patientName': aiSummary.patientName,
        'dateLabel': aiSummary.dateLabel,
        'body': aiSummary.body,
      },
      'recentInsights': [
        for (final r in recentInsights)
          {
            'id': r.id,
            'title': r.title,
            'timestampLabel': r.timestampLabel,
            'description': r.description,
          },
      ],
    });
  }
}
