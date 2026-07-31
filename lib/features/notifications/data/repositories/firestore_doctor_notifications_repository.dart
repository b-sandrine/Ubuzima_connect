import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
/// No seed data — there's no real event/trigger system generating clinical
/// alerts yet, so a fresh account reads back an empty feed instead of
/// fabricated demo content.
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

  @override
  Future<List<NotificationSection>> getSections() async {
    try {
      final docs = await _notifications.orderBy('sortOrder').get();
      final sections = <String, List<NotificationItem>>{};

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
