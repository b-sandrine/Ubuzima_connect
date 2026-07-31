import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/ai_health_insight.dart';
import '../../../domain/models/bp_trend_point.dart';
import '../../../domain/models/care_item.dart';
import '../../../domain/models/health_score.dart';
import '../../../domain/models/medication_reminder.dart';
import '../../../domain/models/patient_profile.dart';
import '../../../domain/models/quick_link.dart';
import '../../../domain/models/vital_reading.dart';
import '../local/patient_dashboard_local_data_source.dart';

/// Firestore-backed source for the patient Home dashboard. Layout:
///
///   patient_dashboard/{patientId} → one document holding every section as
///                                   a field/array — none of it is
///                                   independently mutated by id today, so
///                                   a single doc (no subcollections) keeps
///                                   this simple.
///
/// Seeded from [PatientDashboardLocalDataSource] on first read. Icon/colour
/// for vitals, medications, care items and quick links stay a local
/// cosmetic lookup by id — only the descriptive/numeric fields are read
/// from Firestore.
abstract interface class PatientDashboardRemoteDataSource {
  Future<PatientProfile> readPatient();

  Future<HealthScore> readHealthScore();

  Future<List<VitalReading>> readTodayVitals();

  Future<List<MedicationReminder>> readMedicationReminders();

  Future<List<CareItem>> readUpcomingCare();

  Future<AiHealthInsight> readAiHealthInsight();

  Future<List<QuickLink>> readQuickLinks();

  Future<List<BpTrendPoint>> readBpTrend();
}

@LazySingleton(as: PatientDashboardRemoteDataSource)
class PatientDashboardRemoteDataSourceImpl
    implements PatientDashboardRemoteDataSource {
  final FirebaseFirestore _firestore;
  final PatientDashboardLocalDataSource _seed;

  PatientDashboardRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.patientDashboard)
      .doc(AppConstants.demoPatientId);

  @override
  Future<PatientProfile> readPatient() async {
    final data = await _readOrSeed();
    final patient = (data['patient'] as Map?)?.cast<String, dynamic>() ?? {};
    return PatientProfile(
      id: patient['id'] as String? ?? '',
      fullName: patient['fullName'] as String? ?? '',
      displayId: patient['displayId'] as String? ?? '',
      dateLabel: patient['dateLabel'] as String? ?? '',
      photoUrl: patient['photoUrl'] as String?,
      verified: patient['verified'] as bool? ?? false,
    );
  }

  @override
  Future<HealthScore> readHealthScore() async {
    final data = await _readOrSeed();
    final score = (data['healthScore'] as Map?)?.cast<String, dynamic>() ?? {};
    return HealthScore(
      score: (score['score'] as num?)?.toInt() ?? 0,
      maxScore: (score['maxScore'] as num?)?.toInt() ?? 100,
      statusLabel: score['statusLabel'] as String? ?? '',
      trendLabel: score['trendLabel'] as String? ?? '',
      weeklyChangeLabel: score['weeklyChangeLabel'] as String? ?? '',
    );
  }

  @override
  Future<List<VitalReading>> readTodayVitals() async {
    final data = await _readOrSeed();
    final cosmeticsById = {
      for (final v in _seed.readTodayVitals()) v.id: v,
    };

    return ((data['vitals'] as List?) ?? const [])
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
  Future<List<MedicationReminder>> readMedicationReminders() async {
    final data = await _readOrSeed();
    final cosmeticsById = {
      for (final m in _seed.readMedicationReminders()) m.id: m,
    };

    return ((data['medications'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((m) {
          final id = m['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return MedicationReminder(
            id: id,
            name: cosmetics?.name ?? '',
            detailLine: m['detailLine'] as String? ?? '',
            icon: cosmetics?.icon ?? LucideIcons.circle,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
            status: MedicationStatus.values.byName(
              m['status'] as String? ?? 'upcoming',
            ),
            pillLabel: m['pillLabel'] as String? ?? '',
            pillColor: cosmetics?.pillColor ?? AppColors.textTertiary,
            pillCaption: m['pillCaption'] as String?,
            streakDays: (m['streakDays'] as num?)?.toInt(),
          );
        })
        .toList();
  }

  @override
  Future<List<CareItem>> readUpcomingCare() async {
    final data = await _readOrSeed();
    final cosmeticsById = {for (final c in _seed.readUpcomingCare()) c.id: c};

    return ((data['careItems'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((c) {
          final id = c['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return CareItem(
            id: id,
            title: c['title'] as String? ?? '',
            subtitle: c['subtitle'] as String? ?? '',
            detail: c['detail'] as String? ?? '',
            dateLabel: c['dateLabel'] as String? ?? '',
            dateColor: cosmetics?.dateColor ?? AppColors.textTertiary,
            icon: cosmetics?.icon ?? LucideIcons.circle,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
            primaryActionLabel: cosmetics?.primaryActionLabel,
            primaryActionIcon: cosmetics?.primaryActionIcon,
            secondaryActionLabel: cosmetics?.secondaryActionLabel,
          );
        })
        .toList();
  }

  @override
  Future<AiHealthInsight> readAiHealthInsight() async {
    final data = await _readOrSeed();
    final insight =
        (data['aiHealthInsight'] as Map?)?.cast<String, dynamic>() ?? {};
    return AiHealthInsight(
      title: insight['title'] as String? ?? '',
      tagLabel: insight['tagLabel'] as String? ?? '',
      message: insight['message'] as String? ?? '',
      updatedLabel: insight['updatedLabel'] as String? ?? '',
    );
  }

  @override
  Future<List<QuickLink>> readQuickLinks() async {
    final data = await _readOrSeed();
    final cosmeticsById = {for (final q in _seed.readQuickLinks()) q.id: q};

    return ((data['quickLinks'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((q) {
          final id = q['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return QuickLink(
            id: id,
            icon: cosmetics?.icon ?? LucideIcons.circle,
            label: cosmetics?.label ?? '',
            color: cosmetics?.color ?? AppColors.textTertiary,
            selected: q['selected'] as bool? ?? false,
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

  Future<Map<String, dynamic>> _readOrSeed() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists) {
        await _seedFirestore();
        return (await _doc.get()).data() ?? const {};
      }
      return snapshot.data() ?? const {};
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the dashboard.');
    }
  }

  Future<void> _seedFirestore() async {
    final patient = _seed.readPatient();
    final healthScore = _seed.readHealthScore();
    final vitals = _seed.readTodayVitals();
    final medications = _seed.readMedicationReminders();
    final careItems = _seed.readUpcomingCare();
    final aiInsight = _seed.readAiHealthInsight();
    final quickLinks = _seed.readQuickLinks();
    final bpTrend = _seed.readBpTrend();

    await _doc.set({
      'patient': {
        'id': patient.id,
        'fullName': patient.fullName,
        'displayId': patient.displayId,
        'dateLabel': patient.dateLabel,
        'photoUrl': patient.photoUrl,
        'verified': patient.verified,
      },
      'healthScore': {
        'score': healthScore.score,
        'maxScore': healthScore.maxScore,
        'statusLabel': healthScore.statusLabel,
        'trendLabel': healthScore.trendLabel,
        'weeklyChangeLabel': healthScore.weeklyChangeLabel,
      },
      'vitals': [
        for (final v in vitals)
          {'id': v.id, 'value': v.value, 'subLabel': v.subLabel, 'badgeLabel': v.badgeLabel},
      ],
      'medications': [
        for (final m in medications)
          {
            'id': m.id,
            'detailLine': m.detailLine,
            'status': m.status.name,
            'pillLabel': m.pillLabel,
            'pillCaption': m.pillCaption,
            'streakDays': m.streakDays,
          },
      ],
      'careItems': [
        for (final c in careItems)
          {
            'id': c.id,
            'title': c.title,
            'subtitle': c.subtitle,
            'detail': c.detail,
            'dateLabel': c.dateLabel,
          },
      ],
      'aiHealthInsight': {
        'title': aiInsight.title,
        'tagLabel': aiInsight.tagLabel,
        'message': aiInsight.message,
        'updatedLabel': aiInsight.updatedLabel,
      },
      'quickLinks': [
        for (final q in quickLinks) {'id': q.id, 'selected': q.selected},
      ],
      'bpTrend': [
        for (final p in bpTrend)
          {'dayLabel': p.dayLabel, 'systolic': p.systolic, 'diastolic': p.diastolic},
      ],
    });
  }
}
