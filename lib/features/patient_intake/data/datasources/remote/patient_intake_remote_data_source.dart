import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/entities/patient_intake_draft.dart';

/// Firestore-backed sink for new patient registrations — writes one document
/// per patient to `patients/{autoId}`. Read back today by nothing else in
/// the app (the CHW health record and doctor screens still read the seeded
/// demo patient), so this is additive: every registration lands in the same
/// collection those screens already use, ready for a later screen to list.
abstract interface class PatientIntakeRemoteDataSource {
  Future<String> submitPatientIntake(PatientIntakeDraft draft);
}

@LazySingleton(as: PatientIntakeRemoteDataSource)
class PatientIntakeRemoteDataSourceImpl
    implements PatientIntakeRemoteDataSource {
  final FirebaseFirestore _firestore;

  PatientIntakeRemoteDataSourceImpl(this._firestore);

  @override
  Future<String> submitPatientIntake(PatientIntakeDraft draft) async {
    try {
      final doc = _firestore.collection(FirestorePaths.patients).doc();
      await doc.set(_toMap(draft));
      return doc.id;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not register the patient.');
    }
  }

  Map<String, dynamic> _toMap(PatientIntakeDraft draft) {
    final risk = PatientRiskCalculator.calculate(draft);

    return {
      'registeredAt': FieldValue.serverTimestamp(),
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
}
