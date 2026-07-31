import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/notification_item.dart';
import '../../../domain/models/notification_section.dart';
import '../local/patient_notifications_local_data_source.dart';

/// Firestore-backed source for the patient Alerts feed. Layout:
///
///   notifications/{patientId} → a `sections` array, each holding its own
///                                `items` array
///
/// Seeded from [PatientNotificationsLocalDataSource] on first read. Icon,
/// colour, badge style and action affordances stay a local cosmetic lookup
/// by section title / item id — only title/description/timestamp/read
/// state are read from Firestore.
abstract interface class PatientNotificationsRemoteDataSource {
  Future<List<NotificationSection>> readSections();
}

@LazySingleton(as: PatientNotificationsRemoteDataSource)
class PatientNotificationsRemoteDataSourceImpl
    implements PatientNotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final PatientNotificationsLocalDataSource _seed;

  PatientNotificationsRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.notifications)
      .doc(AppConstants.demoPatientId);

  @override
  Future<List<NotificationSection>> readSections() async {
    try {
      final snapshot = await _doc.get();
      final data = snapshot.exists
          ? snapshot.data() ?? const {}
          : await _seedAndRead();
      return _assemble(data);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load notifications.');
    }
  }

  List<NotificationSection> _assemble(Map<String, dynamic> data) {
    final cosmeticSections = {
      for (final section in _seed.readSections()) section.title: section,
    };
    final cosmeticItemsById = {
      for (final section in _seed.readSections())
        for (final item in section.items) item.id: item,
    };

    return ((data['sections'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((s) {
          final title = s['title'] as String? ?? '';
          final sectionCosmetics = cosmeticSections[title];

          return NotificationSection(
            title: title,
            icon: sectionCosmetics?.icon ?? LucideIcons.bell,
            color: sectionCosmetics?.color ?? AppColors.textTertiary,
            items: ((s['items'] as List?) ?? const [])
                .cast<Map<String, dynamic>>()
                .map((i) {
                  final id = i['id'] as String? ?? '';
                  final cosmetics = cosmeticItemsById[id];
                  return NotificationItem(
                    id: id,
                    title: i['title'] as String? ?? '',
                    subtitleLine: i['subtitleLine'] as String? ?? '',
                    description: i['description'] as String? ?? '',
                    timestampLabel: i['timestampLabel'] as String? ?? '',
                    badgeLabel:
                        i['badgeLabel'] as String? ??
                        cosmetics?.badgeLabel ??
                        '',
                    badgeColor: cosmetics?.badgeColor ?? AppColors.textTertiary,
                    badgeFilled: cosmetics?.badgeFilled ?? true,
                    accentColor:
                        cosmetics?.accentColor ?? AppColors.textTertiary,
                    icon: cosmetics?.icon ?? LucideIcons.bell,
                    avatarUrl: cosmetics?.avatarUrl,
                    actionLabel: cosmetics?.actionLabel,
                    actionIcon: cosmetics?.actionIcon,
                    isRead: i['isRead'] as bool? ?? false,
                  );
                })
                .toList(),
          );
        })
        .toList();
  }

  Future<Map<String, dynamic>> _seedAndRead() async {
    await _seedFirestore();
    return (await _doc.get()).data() ?? const {};
  }

  Future<void> _seedFirestore() async {
    final sections = _seed.readSections();

    await _doc.set({
      'sections': [
        for (final section in sections)
          {
            'title': section.title,
            'items': [
              for (final item in section.items)
                {
                  'id': item.id,
                  'title': item.title,
                  'subtitleLine': item.subtitleLine,
                  'description': item.description,
                  'timestampLabel': item.timestampLabel,
                  'badgeLabel': item.badgeLabel,
                  'isRead': item.isRead,
                },
            ],
          },
      ],
    });
  }
}
