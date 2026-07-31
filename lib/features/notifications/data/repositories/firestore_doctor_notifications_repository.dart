import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/models/notification_section.dart';
import '../../domain/repositories/notifications_repository.dart';

const Map<String, IconData> _iconByKey = {
  'triangleAlert': LucideIcons.triangleAlert,
  'calendarClock': LucideIcons.calendarClock,
  'share2': LucideIcons.share2,
  'pill': LucideIcons.pill,
  'userRound': LucideIcons.userRound,
  'bell': LucideIcons.bell,
};

const Map<String, Color> _colorByKey = {
  'danger': AppColors.danger,
  'secondary': AppColors.secondary,
  'warning': AppColors.warning,
  'success': AppColors.success,
  'primary': AppColors.primary,
};

/// Firestore-backed [NotificationsRepository] for the doctor audience,
/// scoped to the signed-in doctor's own uid:
///
///   doctors/{uid}/notifications/{id} → flat notification documents, each
///     tagged with a `sectionTitle` grouped into a [NotificationSection]
///     here, in the order sections first appear.
///
/// Also derives live "Priority Alerts" / "Referral Updates" entries from
/// the real `referrals` collection DOC-06 owns (incoming, not declined) —
/// there's no real event/trigger system writing to `notifications` yet, so
/// without this a referred patient would never show up as an alert at all.
@LazySingleton()
class FirestoreDoctorNotificationsRepository
    implements NotificationsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreDoctorNotificationsRepository(this._firestore, this._auth);

  String get _uid => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _notifications => _firestore
      .collection(FirestorePaths.doctors)
      .doc(_uid)
      .collection('notifications');

  CollectionReference<Map<String, dynamic>> get _referrals =>
      _firestore.collection(FirestorePaths.referrals);

  DocumentReference<Map<String, dynamic>> get _referralPatientDoc => _firestore
      .collection(FirestorePaths.patients)
      .doc(AppConstants.demoPatientId);

  @override
  Future<List<NotificationSection>> getSections() async {
    try {
      final sections = <String, List<NotificationItem>>{};
      await _addReferralNotifications(sections);

      final docs = await _notifications.orderBy('sortOrder').get();
      for (final d in docs.docs) {
        final data = d.data();
        final title = data['sectionTitle'] as String? ?? 'Notifications';
        sections
            .putIfAbsent(title, () => [])
            .add(
              NotificationItem(
                id: d.id,
                title: data['title'] as String? ?? '',
                subtitleLine: data['subtitleLine'] as String? ?? '',
                description: data['description'] as String? ?? '',
                timestampLabel: data['timestampLabel'] as String? ?? '',
                badgeLabel: data['badgeLabel'] as String? ?? '',
                badgeColor:
                    _colorByKey[data['badgeColorKey'] as String? ?? ''] ??
                    AppColors.secondary,
                badgeFilled: data['badgeFilled'] as bool? ?? true,
                accentColor:
                    _colorByKey[data['accentColorKey'] as String? ?? ''] ??
                    AppColors.secondary,
                icon: _iconByKey[data['iconKey'] as String? ?? ''] ??
                    LucideIcons.bell,
                avatarUrl: data['avatarUrl'] as String?,
                actionLabel: data['actionLabel'] as String?,
                actionIcon: data['actionIconKey'] == null
                    ? null
                    : _iconByKey[data['actionIconKey'] as String],
                isRead: data['isRead'] as bool? ?? false,
              ),
            );
      }

      return [
        for (final entry in sections.entries)
          NotificationSection(
            title: entry.key,
            icon: _sectionIcon(entry.key),
            color: _sectionColor(entry.key),
            items: entry.value,
          ),
      ];
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load notifications.');
    }
  }

  /// Adds one notification per incoming, non-declined referral — urgent
  /// ones under "Priority Alerts" (with an Accept Referral action), the
  /// rest under "Referral Updates" (View Patient) — inserted before any
  /// stored notifications so the live, real signal always appears first.
  Future<void> _addReferralNotifications(
    Map<String, List<NotificationItem>> sections,
  ) async {
    final referralDocs = await _referrals
        .where('direction', isEqualTo: 'incoming')
        .get();
    final relevant = referralDocs.docs.where(
      (d) => d.data()['status'] != 'declined',
    );
    if (relevant.isEmpty) return;

    final patientName =
        (await _referralPatientDoc.get()).data()?['name'] as String? ?? '';

    for (final d in relevant) {
      final data = d.data();
      final isUrgent = data['urgency'] == 'urgent';
      final title = isUrgent ? 'Priority Alerts' : 'Referral Updates';
      final specialty = data['specialty'] as String? ?? 'Specialist';

      sections
          .putIfAbsent(title, () => [])
          .add(
            NotificationItem(
              id: 'referral-${d.id}',
              title: isUrgent
                  ? 'Urgent Referral · $specialty'
                  : 'New Referral · $specialty',
              subtitleLine: patientName,
              description: data['reason'] as String? ?? '',
              timestampLabel: data['receivedLabel'] as String? ?? '',
              badgeLabel: isUrgent ? 'URGENT' : 'New',
              badgeColor: isUrgent ? AppColors.danger : AppColors.success,
              accentColor: isUrgent ? AppColors.danger : AppColors.success,
              icon: isUrgent ? LucideIcons.triangleAlert : LucideIcons.share2,
              actionLabel: isUrgent ? 'Accept Referral' : 'View Patient',
              actionIcon: isUrgent
                  ? LucideIcons.check
                  : LucideIcons.userRound,
            ),
          );
    }
  }

  IconData _sectionIcon(String title) => switch (title) {
    'Priority Alerts' => LucideIcons.triangleAlert,
    'Appointment Reminders' => LucideIcons.calendarClock,
    'Referral Updates' => LucideIcons.share2,
    _ => LucideIcons.bell,
  };

  Color _sectionColor(String title) => switch (title) {
    'Priority Alerts' => AppColors.danger,
    'Appointment Reminders' => AppColors.secondary,
    'Referral Updates' => AppColors.success,
    _ => AppColors.secondary,
  };
}
