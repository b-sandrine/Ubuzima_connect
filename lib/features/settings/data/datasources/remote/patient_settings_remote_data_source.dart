import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/emergency_contact.dart';
import '../../../domain/models/user_profile_summary.dart';
import '../local/patient_settings_local_data_source.dart';

/// Firestore-backed source for the patient Settings screen. Layout:
///
///   settings/{patientId} → profile fields + an emergencyContacts array
///
/// Seeded from [PatientSettingsLocalDataSource] on first read. Icon/colour
/// for each emergency contact stay a local cosmetic lookup by id — only the
/// name/relationship/phone are read from Firestore.
abstract interface class PatientSettingsRemoteDataSource {
  Future<UserProfileSummary> readProfile();

  Future<List<EmergencyContact>> readEmergencyContacts();
}

@LazySingleton(as: PatientSettingsRemoteDataSource)
class PatientSettingsRemoteDataSourceImpl
    implements PatientSettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final PatientSettingsLocalDataSource _seed;

  PatientSettingsRemoteDataSourceImpl(this._firestore, this._seed);

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.settings)
      .doc(AppConstants.demoPatientId);

  @override
  Future<UserProfileSummary> readProfile() async {
    final data = await _readOrSeed();
    return UserProfileSummary(
      fullName: data['fullName'] as String? ?? '',
      roleLabel: data['roleLabel'] as String? ?? '',
      facility: data['facility'] as String? ?? '',
      displayId: data['displayId'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      accentColor: _seed.readProfile().accentColor,
    );
  }

  @override
  Future<List<EmergencyContact>> readEmergencyContacts() async {
    final data = await _readOrSeed();
    final cosmeticsById = {
      for (final contact in _seed.readEmergencyContacts()) contact.id: contact,
    };

    return ((data['emergencyContacts'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map((c) {
          final id = c['id'] as String? ?? '';
          final cosmetics = cosmeticsById[id];
          return EmergencyContact(
            id: id,
            name: c['name'] as String? ?? '',
            relationship: c['relationship'] as String? ?? '',
            phoneNumber: c['phoneNumber'] as String? ?? '',
            icon: cosmetics?.icon ?? LucideIcons.userRound,
            iconColor: cosmetics?.iconColor ?? AppColors.textTertiary,
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
      throw ServerException(e.message ?? 'Could not load settings.');
    }
  }

  Future<void> _seedFirestore() async {
    final profile = _seed.readProfile();
    final contacts = _seed.readEmergencyContacts();

    await _doc.set({
      'fullName': profile.fullName,
      'roleLabel': profile.roleLabel,
      'facility': profile.facility,
      'displayId': profile.displayId,
      'photoUrl': profile.photoUrl,
      'isActive': profile.isActive,
      'emergencyContacts': [
        for (final contact in contacts)
          {
            'id': contact.id,
            'name': contact.name,
            'relationship': contact.relationship,
            'phoneNumber': contact.phoneNumber,
          },
      ],
    });
  }
}
