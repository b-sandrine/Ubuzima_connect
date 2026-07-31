import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/patient_intake_draft.dart';
import '../../../domain/entities/registered_patient.dart';

/// Firestore API for patient registration documents under `patients/{id}`.
///
/// Create writes the nested intake schema (+ `ownerId` when signed in).
/// List reads documents that have `registeredAt` (intake registrations),
/// which excludes the seeded demo health-record docs that use a flat schema.
abstract interface class PatientIntakeRemoteDataSource {
  Future<String> submitPatientIntake(PatientIntakeDraft draft);

  /// Registered patients newest-first. When [forCurrentUserOnly] is true and
  /// a Firebase user is signed in, results are scoped to `ownerId == uid`.
  Future<List<RegisteredPatient>> listRegisteredPatients({
    bool forCurrentUserOnly = false,
  });
}

@LazySingleton(as: PatientIntakeRemoteDataSource)
class PatientIntakeRemoteDataSourceImpl
    implements PatientIntakeRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PatientIntakeRemoteDataSourceImpl(this._firestore, this._auth);

  CollectionReference<Map<String, dynamic>> get _patients =>
      _firestore.collection(FirestorePaths.patients);

  @override
  Future<String> submitPatientIntake(PatientIntakeDraft draft) async {
    try {
      final doc = _patients.doc();
      await doc.set(_toMap(draft));
      return doc.id;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not register the patient.');
    }
  }

  @override
  Future<List<RegisteredPatient>> listRegisteredPatients({
    bool forCurrentUserOnly = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _patients.orderBy(
        'registeredAt',
        descending: true,
      );

      final uid = _auth.currentUser?.uid;
      if (forCurrentUserOnly && uid != null) {
        query = _patients
            .where('ownerId', isEqualTo: uid)
            .orderBy('registeredAt', descending: true);
      }

      final snap = await query.get();
      return snap.docs
          .map(_fromDoc)
          .where((p) => p.fullName.trim().isNotEmpty)
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load patients.');
    }
  }

  RegisteredPatient _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final identity =
        (data['identity'] as Map?)?.cast<String, dynamic>() ?? const {};
    final household =
        (data['household'] as Map?)?.cast<String, dynamic>() ?? const {};
    final contact =
        (data['contact'] as Map?)?.cast<String, dynamic>() ?? const {};
    final risk =
        (data['riskAssessment'] as Map?)?.cast<String, dynamic>() ?? const {};

    final dobRaw = identity['dateOfBirth'] as String?;
    final registered = data['registeredAt'];

    return RegisteredPatient(
      id: doc.id,
      fullName: identity['fullName'] as String? ?? '',
      gender: identity['gender'] as String?,
      dateOfBirth: dobRaw != null ? DateTime.tryParse(dobRaw) : null,
      phone:
          (contact['primaryPhone'] as String?)?.trim().isNotEmpty == true
          ? contact['primaryPhone'] as String
          : identity['phone'] as String?,
      district: household['district'] as String?,
      province: household['province'] as String?,
      riskScore: (risk['score'] as num?)?.toInt() ?? 0,
      riskLevel: _risk(risk['level'] as String?),
      registeredAt: registered is Timestamp ? registered.toDate() : null,
    );
  }

  Map<String, dynamic> _toMap(PatientIntakeDraft draft) {
    final risk = PatientRiskCalculator.calculate(draft);
    final uid = _auth.currentUser?.uid;

    return {
      'registeredAt': FieldValue.serverTimestamp(),
      'ownerId': ?uid,
      'identity': {
        'fullName': draft.fullName,
        'nationalId': draft.nationalId,
        'dateOfBirth': draft.dateOfBirth?.toIso8601String(),
        'gender': draft.gender?.name,
        'phone': draft.identityPhone,
      },
      'household': {
        'province': draft.province,
        'district': draft.district,
        'sector': draft.sector,
        'cell': draft.cell,
        'village': draft.village,
        'householdSize': draft.householdSize,
        'headOfHousehold': draft.headOfHousehold,
        'ubudeheCategory': draft.ubudeheCategory,
      },
      'contact': {
        'primaryPhone': draft.primaryPhone,
        'alternatePhone': draft.alternatePhone,
        'emergencyContactName': draft.emergencyContactName,
        'relationship': draft.relationship,
        'emergencyContactPhone': draft.emergencyContactPhone,
      },
      'demographics': {
        'maritalStatus': draft.maritalStatus?.name,
        'educationLevel': draft.educationLevel,
        'occupation': draft.occupation,
        'insurance': draft.insurance?.name,
        'insuranceNumber': draft.insuranceNumber,
      },
      'location': {
        'streetAddress': draft.streetAddress,
        'nearestLandmark': draft.nearestLandmark,
        'gpsCaptured': draft.gpsCaptured,
      },
      'qrCaptured': draft.qrCaptured,
      'symptoms': {
        'duration': draft.symptomDuration?.name,
        'reported': draft.reportedSymptoms.toList(),
        'additionalNotes': draft.additionalNotes,
      },
      'riskScreening': {
        'chronicConditions': draft.chronicConditions.toList(),
        'pregnancyStatus': draft.pregnancyStatus?.name,
        'vaccinationStatus': draft.vaccinationStatus?.name,
      },
      'emergencyFlags': draft.emergencyFlags.map((f) => f.name).toList(),
      'riskAssessment': {'score': risk.score, 'level': risk.level.name},
    };
  }

  static RiskLevel _risk(String? raw) {
    return RiskLevel.values.firstWhere(
      (v) => v.name == raw,
      orElse: () => RiskLevel.moderate,
    );
  }
}
