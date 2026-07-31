import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/ai/clinical_ai_service.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/domain/models/notification_item.dart';
import '../../../notifications/domain/models/notification_section.dart';
import '../../../notifications/domain/repositories/notifications_repository.dart';
import '../../../patient_intake/domain/entities/patient_intake_draft.dart';
import '../../domain/entities/chw_day_briefing.dart';
import '../../domain/entities/chw_upcoming_visit.dart';

/// Builds CHW alerts, upcoming visits, and the AI day briefing from live
/// `patients/{id}` docs and `next_steps` subcollections.
@lazySingleton
class ChwCaseloadRepository implements NotificationsRepository {
  final FirebaseFirestore _firestore;
  final ClinicalAiService _ai;

  ChwCaseloadRepository(this._firestore, this._ai);

  CollectionReference<Map<String, dynamic>> get _patients =>
      _firestore.collection(FirestorePaths.patients);

  Future<QuerySnapshot<Map<String, dynamic>>> _recentPatients({
    int limit = 40,
  }) {
    return _patients.orderBy('registeredAt', descending: true).limit(limit).get();
  }

  @override
  Future<List<NotificationSection>> getSections() async {
    final snap = await _recentPatients();
    return _sectionsFromSnap(snap);
  }

  Future<List<ChwEmergencyAlert>> listEmergencyAlerts({int limit = 5}) async {
    final snap = await _recentPatients();
    final alerts = <ChwEmergencyAlert>[];

    for (final doc in snap.docs) {
      if (alerts.length >= limit) break;
      final data = doc.data();
      final identity =
          (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = identity['fullName'] as String? ?? '';
      if (name.trim().isEmpty) continue;

      final flags =
          ((data['emergencyFlags'] as List?) ?? const []).cast<String>();
      if (flags.isEmpty) continue;

      final risk =
          (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ??
          const {};
      alerts.add(
        ChwEmergencyAlert(
          patientId: doc.id,
          patientName: name,
          location: _location(data),
          flags: flags,
          riskLevel:
              risk['level'] as String? ?? data['riskLevel'] as String? ?? 'high',
        ),
      );
    }
    return alerts;
  }

  Future<ChwDayBriefing> getDayBriefing({
    List<ChwEmergencyAlert>? emergencies,
    List<ChwUpcomingVisit>? visits,
    int? patientCount,
    int? alertCount,
  }) async {
    final emergencyList = emergencies ?? await listEmergencyAlerts();
    final visitList = visits ?? await listUpcomingVisits();
    final patientsSnap = await _recentPatients(limit: 25);

    final highRisk = <String>[];
    for (final doc in patientsSnap.docs) {
      final data = doc.data();
      final identity =
          (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = identity['fullName'] as String? ?? '';
      if (name.trim().isEmpty) continue;
      final risk =
          (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ??
          const {};
      final level = _risk(risk['level'] as String? ?? data['riskLevel'] as String?);
      if (level == RiskLevel.high || level == RiskLevel.critical) {
        highRisk.add(
          '$name (${level.name}, score ${(risk['score'] as num?)?.toInt() ?? '—'})',
        );
      }
    }

    final totalPatients = patientCount ?? patientsSnap.docs.length;
    final totalAlerts = alertCount ?? (await this.alertCount());

    final context = StringBuffer()
      ..writeln('CHW day briefing context:')
      ..writeln('Registered patients in caseload sample: $totalPatients')
      ..writeln('Active alerts: $totalAlerts')
      ..writeln('Upcoming visits: ${visitList.length}')
      ..writeln('Emergency patients:');
    if (emergencyList.isEmpty) {
      context.writeln('- none');
    } else {
      for (final e in emergencyList) {
        context.writeln(
          '- ${e.patientName} @ ${e.location.isEmpty ? 'unknown location' : e.location}: ${e.flagsLabel}',
        );
      }
    }
    context.writeln('High/critical risk patients:');
    if (highRisk.isEmpty) {
      context.writeln('- none');
    } else {
      for (final line in highRisk.take(8)) {
        context.writeln('- $line');
      }
    }
    context.writeln('Upcoming visits:');
    if (visitList.isEmpty) {
      context.writeln('- none');
    } else {
      for (final v in visitList.take(6)) {
        context.writeln(
          '- ${v.timeLabel} ${v.patientName}: ${v.type} (${v.detail})',
        );
      }
    }

    final summary = await _ai.generateChwDayBriefing(
      clinicalContext: context.toString(),
    );

    final recommendations = <String>[
      if (emergencyList.isNotEmpty)
        'See ${emergencyList.first.patientName} today — ${emergencyList.first.flagsLabel}',
      if (highRisk.isNotEmpty)
        'Follow up high-risk patients: ${highRisk.take(2).join('; ')}',
      if (visitList.isNotEmpty)
        'Complete ${visitList.length} scheduled visit${visitList.length == 1 ? '' : 's'} (next: ${visitList.first.patientName})',
      if (emergencyList.isEmpty && highRisk.isEmpty && visitList.isEmpty)
        'Do a routine household check-in and keep screening for danger signs',
    ];

    return ChwDayBriefing(
      summary: summary,
      recommendations: recommendations.take(4).toList(),
    );
  }

  List<NotificationSection> _sectionsFromSnap(
    QuerySnapshot<Map<String, dynamic>> snap,
  ) {
    final riskItems = <NotificationItem>[];
    final emergencyItems = <NotificationItem>[];

    for (final doc in snap.docs) {
      final data = doc.data();
      final identity =
          (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = identity['fullName'] as String? ?? '';
      if (name.trim().isEmpty) continue;

      final risk =
          (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ??
          const {};
      final level = _risk(
        risk['level'] as String? ?? data['riskLevel'] as String?,
      );
      final flags =
          ((data['emergencyFlags'] as List?) ?? const []).cast<String>();
      final location = _location(data);

      if (level == RiskLevel.high || level == RiskLevel.critical) {
        riskItems.add(
          NotificationItem(
            id: 'risk-${doc.id}',
            title: name,
            subtitleLine: location.isEmpty ? 'Community patient' : location,
            description:
                '${_title(level.name)} risk score ${(risk['score'] as num?)?.toInt() ?? '—'} — review and follow up.',
            timestampLabel: 'Needs attention',
            badgeLabel: level.name.toUpperCase(),
            badgeColor: level == RiskLevel.critical
                ? AppColors.riskCritical
                : AppColors.riskHigh,
            accentColor: level == RiskLevel.critical
                ? AppColors.riskCritical
                : AppColors.riskHigh,
            icon: LucideIcons.triangleAlert,
            actionLabel: 'Open record',
            actionIcon: LucideIcons.fileHeart,
          ),
        );
      }

      if (flags.isNotEmpty) {
        emergencyItems.add(
          NotificationItem(
            id: 'flag-${doc.id}',
            title: name,
            subtitleLine: 'Emergency screening flags',
            description: flags
                .map((f) => _title(f.replaceAll('_', ' ')))
                .join(' · '),
            timestampLabel: 'Urgent',
            badgeLabel: 'FLAG',
            badgeColor: AppColors.danger,
            accentColor: AppColors.danger,
            icon: LucideIcons.siren,
            actionLabel: 'Open record',
            actionIcon: LucideIcons.fileHeart,
          ),
        );
      }
    }

    return [
      if (emergencyItems.isNotEmpty)
        NotificationSection(
          title: 'Emergency Flags',
          icon: LucideIcons.siren,
          color: AppColors.danger,
          items: emergencyItems,
        ),
      if (riskItems.isNotEmpty)
        NotificationSection(
          title: 'High Risk Patients',
          icon: LucideIcons.triangleAlert,
          color: AppColors.warning,
          items: riskItems,
        ),
      if (emergencyItems.isEmpty && riskItems.isEmpty)
        NotificationSection(
          title: 'All Clear',
          icon: LucideIcons.shieldCheck,
          color: AppColors.primary,
          items: const [
            NotificationItem(
              id: 'clear',
              title: 'No active alerts',
              subtitleLine: 'Community caseload',
              description:
                  'No high-risk patients or emergency flags right now. Keep monitoring visits.',
              timestampLabel: 'Live',
              badgeLabel: 'OK',
              badgeColor: AppColors.primary,
              accentColor: AppColors.primary,
              icon: LucideIcons.checkCheck,
              isRead: true,
            ),
          ],
        ),
    ];
  }

  /// Pending visit-style next steps across recent patients, newest first.
  Future<List<ChwUpcomingVisit>> listUpcomingVisits({int limit = 8}) async {
    final patients = await _patients
        .orderBy('registeredAt', descending: true)
        .limit(25)
        .get();

    final visits = <ChwUpcomingVisit>[];

    for (final doc in patients.docs) {
      if (visits.length >= limit) break;
      final data = doc.data();
      final identity =
          (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = identity['fullName'] as String? ?? '';
      if (name.trim().isEmpty) continue;

      final steps = await doc.reference
          .collection('next_steps')
          .orderBy('sortOrder')
          .get();

      final visitSteps = steps.docs.where((s) {
        final kind = s.data()['kind'] as String? ?? 'visit';
        return kind == 'visit' || kind == 'check';
      });

      for (final step in visitSteps) {
        if (visits.length >= limit) break;
        final s = step.data();
        visits.add(
          ChwUpcomingVisit(
            id: step.id,
            patientId: doc.id,
            patientName: name,
            type: s['title'] as String? ?? 'Community visit',
            timeLabel: s['badge'] as String? ?? 'Soon',
            detail: s['detail'] as String? ?? '',
          ),
        );
      }
    }

    if (visits.isNotEmpty) return visits;

    // Fallback: schedule follow-ups for elevated-risk registrations.
    for (final doc in patients.docs) {
      if (visits.length >= limit) break;
      final data = doc.data();
      final identity =
          (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
      final name = identity['fullName'] as String? ?? '';
      if (name.trim().isEmpty) continue;
      final risk =
          (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ??
          const {};
      final level = _risk(risk['level'] as String?);
      if (level == RiskLevel.low) continue;

      final registered = data['registeredAt'];
      final when = registered is Timestamp
          ? registered.toDate().add(const Duration(days: 3))
          : DateTime.now().add(const Duration(days: 2));

      visits.add(
        ChwUpcomingVisit(
          id: 'followup-${doc.id}',
          patientId: doc.id,
          patientName: name,
          type: '${_title(level.name)} risk follow-up',
          timeLabel: DateFormat('HH:mm').format(when),
          detail: DateFormat('EEE, dd MMM').format(when),
        ),
      );
    }

    return visits;
  }

  Future<int> alertCount() async {
    final sections = await getSections();
    var count = 0;
    for (final section in sections) {
      if (section.title == 'All Clear') continue;
      count += section.items.length;
    }
    return count;
  }

  String _location(Map<String, dynamic> data) {
    final household =
        (data['household'] as Map?)?.cast<String, dynamic>() ?? const {};
    final parts = [
      if ((household['district'] as String?)?.isNotEmpty == true)
        household['district'] as String,
      if ((household['province'] as String?)?.isNotEmpty == true)
        household['province'] as String,
    ];
    return parts.join(', ');
  }

  RiskLevel _risk(String? raw) => RiskLevel.values.firstWhere(
    (v) => v.name == raw,
    orElse: () => RiskLevel.moderate,
  );

  String _title(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
