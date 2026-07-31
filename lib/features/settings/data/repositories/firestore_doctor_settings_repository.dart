import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/emergency_contact.dart';
import '../../domain/models/user_profile_summary.dart';
import '../../domain/repositories/settings_repository.dart';

/// Small, stable key → [IconData]/[Color] lookups, same approach as the
/// doctors feature's patient-detail data source — Firestore stores the key,
/// not the Flutter type.
const Map<String, IconData> _iconByKey = {
  'userRound': LucideIcons.userRound,
  'shield': LucideIcons.shield,
  'phone': LucideIcons.phone,
};

const Map<String, Color> _colorByKey = {
  'secondary': AppColors.secondary,
  'warning': AppColors.warning,
  'danger': AppColors.danger,
  'primary': AppColors.primary,
};

/// Firestore-backed [SettingsRepository] for the doctor audience, scoped
/// to the signed-in doctor's own uid:
///
///   users/{uid}                            → real identity (name/email),
///                                             written by registration
///   doctors/{uid}                          → doctor-only extras
///                                             (hospital), shared with the
///                                             dashboard/patient-search data
///   doctors/{uid}/emergency_contacts/{id}  → this screen's contacts list
///
/// No seed data — a fresh account reads back the real registered name with
/// an empty contacts list until contacts are added.
@LazySingleton()
class FirestoreDoctorSettingsRepository implements SettingsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreDoctorSettingsRepository(this._firestore, this._auth);

  String get _uid => _auth.currentUser?.uid ?? '';

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection(FirestorePaths.users).doc(_uid);

  DocumentReference<Map<String, dynamic>> get _doctorDoc =>
      _firestore.collection(FirestorePaths.doctors).doc(_uid);

  CollectionReference<Map<String, dynamic>> get _emergencyContacts =>
      _doctorDoc.collection('emergency_contacts');

  @override
  Future<UserProfileSummary> getProfile() async {
    try {
      final results = await Future.wait([_userDoc.get(), _doctorDoc.get()]);
      final user = results[0].data() ?? const {};
      final doctor = results[1].data() ?? const {};
      final email = user['email'] as String?;

      return UserProfileSummary(
        fullName: (user['displayName'] as String?)?.trim().isNotEmpty == true
            ? user['displayName'] as String
            : (email ?? ''),
        roleLabel: 'Doctor',
        facility: doctor['hospital'] as String? ?? '',
        displayId: email ?? _uid,
        accentColor: AppColors.roleDoctor,
        photoUrl: user['photoUrl'] as String?,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load your profile.');
    }
  }

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    try {
      final docs = await _emergencyContacts.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return EmergencyContact(
          id: d.id,
          name: data['name'] as String? ?? '',
          relationship: data['relationship'] as String? ?? '',
          phoneNumber: data['phoneNumber'] as String? ?? '',
          icon: _iconByKey[data['iconKey'] as String? ?? ''] ??
              LucideIcons.userRound,
          iconColor: _colorByKey[data['iconColorKey'] as String? ?? ''] ??
              AppColors.secondary,
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Could not load emergency contacts.',
      );
    }
  }
}
