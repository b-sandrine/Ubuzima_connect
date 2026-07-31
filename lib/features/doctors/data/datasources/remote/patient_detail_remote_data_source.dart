import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/models/allergy.dart';
import '../../../domain/models/clinical_note.dart';
import '../../../domain/models/clinical_summary_item.dart';
import '../../../domain/models/patient_detail.dart';
import '../../../domain/models/patient_record.dart';
import '../../../domain/models/risk_indicator.dart';
import '../../../domain/models/vital_sign.dart';

/// Small, stable key → [IconData]/[Color] lookups. Firestore only ever
/// stores the key (e.g. `'heartPulse'`, `'danger'`); the visual value is
/// reconstructed here so the schema never has to carry Flutter types.
const Map<String, IconData> _iconByKey = {
  'heart': LucideIcons.heart,
  'heartPulse': LucideIcons.heartPulse,
  'droplet': LucideIcons.droplet,
  'wind': LucideIcons.wind,
  'thermometer': LucideIcons.thermometer,
  'scale': LucideIcons.scale,
  'activity': LucideIcons.activity,
  'pill': LucideIcons.pill,
  'flaskConical': LucideIcons.flaskConical,
  'calendar': LucideIcons.calendar,
};

const Map<String, Color> _colorByKey = {
  'danger': AppColors.danger,
  'warning': AppColors.warning,
  'success': AppColors.success,
  'secondary': AppColors.secondary,
  'primary': AppColors.primary,
};

/// Firestore-backed store for the Patient Details screen. Operates on the
/// same fixed demo patient id Patient Search/Consultation use until a real
/// patient-selection flow lands. Layout, nested under the patient doc
/// [PatientSearchRemoteDataSource] creates:
///
///   doctors/{doctorId}/patients/{patientId}                      → detail
///     fields (dateOfBirth, hospital) merged onto the search record
///   doctors/{doctorId}/patients/{patientId}/risk_indicators/{id}
///   doctors/{doctorId}/patients/{patientId}/vitals/{id}
///   doctors/{doctorId}/patients/{patientId}/allergies/{id}
///   doctors/{doctorId}/patients/{patientId}/clinical_notes/{id}
///   doctors/{doctorId}/patients/{patientId}/clinical_summary/{id}
///
/// No seed data — a fresh Firestore project reads back empty lists/blank
/// fields until this patient's chart is added directly in Firestore.
abstract interface class PatientDetailRemoteDataSource {
  Future<PatientDetail> getPatientDetail();

  Future<RiskProfile> getRiskProfile();

  Future<List<VitalSign>> getVitals();

  Future<String> getVitalsAsOfLabel();

  Future<List<Allergy>> getAllergies();

  Future<String> getDrugInteractionMessage();

  Future<List<ClinicalNote>> getClinicalNotes();

  Future<List<ClinicalSummaryItem>> getClinicalSummaryItems();
}

@LazySingleton(as: PatientDetailRemoteDataSource)
class PatientDetailRemoteDataSourceImpl
    implements PatientDetailRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PatientDetailRemoteDataSourceImpl(this._firestore, this._auth);

  String get _doctorId => _auth.currentUser?.uid ?? AppConstants.demoDoctorId;

  /// The fixed demo patient this screen operates on — matches the id
  /// Patient Search/Consultation use for the same patient.
  static const String _patientId = 'patient-001';

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection(FirestorePaths.doctors)
      .doc(_doctorId)
      .collection('patients')
      .doc(_patientId);

  CollectionReference<Map<String, dynamic>> get _riskIndicators =>
      _doc.collection('risk_indicators');

  CollectionReference<Map<String, dynamic>> get _vitals =>
      _doc.collection('vitals');

  CollectionReference<Map<String, dynamic>> get _allergies =>
      _doc.collection('allergies');

  CollectionReference<Map<String, dynamic>> get _clinicalNotes =>
      _doc.collection('clinical_notes');

  CollectionReference<Map<String, dynamic>> get _clinicalSummary =>
      _doc.collection('clinical_summary');

  @override
  Future<PatientDetail> getPatientDetail() async {
    try {
      final data = (await _doc.get()).data() ?? const {};
      return PatientDetail(
        id: _patientId,
        name: data['name'] as String? ?? '',
        patientCode: data['patientCode'] as String? ?? '',
        gender: data['detailGender'] as String? ?? '',
        age: (data['age'] as num?)?.toInt() ?? 0,
        dateOfBirth: data['dateOfBirth'] as String? ?? '',
        location: data['location'] as String? ?? '',
        hospital: data['hospital'] as String? ?? '',
        status: PatientRecordStatus.values.byName(
          data['status'] as String? ?? 'routine',
        ),
        tags: ((data['detailTags'] as List?) ?? const []).cast<String>(),
        photoUrl: data['photoUrl'] as String?,
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the patient.');
    }
  }

  @override
  Future<RiskProfile> getRiskProfile() async {
    try {
      final doc = (await _doc.get()).data() ?? const {};
      final docs = await _riskIndicators.orderBy('sortOrder').get();
      return RiskProfile(
        overallLabel: doc['riskOverallLabel'] as String? ?? '',
        overallColor:
            _colorByKey[doc['riskOverallColorKey'] as String? ?? ''] ??
            AppColors.textTertiary,
        indicators: docs.docs.map((d) {
          final data = d.data();
          return RiskIndicator(
            label: data['label'] as String? ?? '',
            percentage: (data['percentage'] as num?)?.toInt() ?? 0,
            icon: _iconByKey[data['iconKey'] as String? ?? ''] ??
                LucideIcons.activity,
            color: _colorByKey[data['colorKey'] as String? ?? ''] ??
                AppColors.textTertiary,
          );
        }).toList(),
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the risk profile.');
    }
  }

  @override
  Future<List<VitalSign>> getVitals() async {
    try {
      final docs = await _vitals.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        final statusName = data['status'] as String?;
        final trendName = data['trend'] as String?;
        return VitalSign(
          label: data['label'] as String? ?? '',
          value: data['value'] as String? ?? '',
          unit: data['unit'] as String? ?? '',
          icon: _iconByKey[data['iconKey'] as String? ?? ''] ??
              LucideIcons.activity,
          status: statusName == null
              ? null
              : VitalStatus.values.byName(statusName),
          trend: trendName == null
              ? null
              : VitalTrendDirection.values.byName(trendName),
          trendText: data['trendText'] as String?,
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load vitals.');
    }
  }

  @override
  Future<String> getVitalsAsOfLabel() async {
    try {
      final data = (await _doc.get()).data() ?? const {};
      return data['vitalsAsOfLabel'] as String? ?? '';
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load vitals timing.');
    }
  }

  @override
  Future<List<Allergy>> getAllergies() async {
    try {
      final docs = await _allergies.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return Allergy(
          label: data['label'] as String? ?? '',
          severity: AllergySeverity.values.byName(
            data['severity'] as String? ?? 'mild',
          ),
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load allergies.');
    }
  }

  @override
  Future<String> getDrugInteractionMessage() async {
    try {
      final data = (await _doc.get()).data() ?? const {};
      return data['drugInteractionMessage'] as String? ?? '';
    } on FirebaseException catch (e) {
      throw ServerException(
        e.message ?? 'Could not load drug interaction flags.',
      );
    }
  }

  @override
  Future<List<ClinicalNote>> getClinicalNotes() async {
    try {
      final docs = await _clinicalNotes.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return ClinicalNote(
          id: d.id,
          authorName: data['authorName'] as String? ?? '',
          authorRole: data['authorRole'] as String? ?? '',
          timeLabel: data['timeLabel'] as String? ?? '',
          note: data['note'] as String? ?? '',
          tags: ((data['tags'] as List?) ?? const []).cast<String>(),
          authorPhotoUrl: data['authorPhotoUrl'] as String?,
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load clinical notes.');
    }
  }

  @override
  Future<List<ClinicalSummaryItem>> getClinicalSummaryItems() async {
    try {
      final docs = await _clinicalSummary.orderBy('sortOrder').get();
      return docs.docs.map((d) {
        final data = d.data();
        return ClinicalSummaryItem(
          icon: _iconByKey[data['iconKey'] as String? ?? ''] ??
              LucideIcons.fileText,
          title: data['title'] as String? ?? '',
          subtitle: data['subtitle'] as String? ?? '',
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load clinical summary.');
    }
  }
}
