import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/firestore_paths.dart';
import '../../../../../core/exceptions/app_exceptions.dart';
import '../../../domain/models/consultation.dart';
import '../../../domain/models/patient_record.dart';

/// Firestore-backed store for the Consultation screen. Operates on the
/// same fixed demo patient id Patient Search/Details use. Layout, nested
/// under the patient doc those screens create:
///
///   doctors/{doctorId}/patients/{patientId}                      → the
///     patient-record fields
///   doctors/{doctorId}/patients/{patientId}/consultation/active   → the
///     session start time and recorded vitals
///
/// No seed data — reads back blank/zeroed fields until a real patient and
/// an active session exist in Firestore.
abstract interface class ConsultationRemoteDataSource {
  Future<Consultation> getActiveConsultation();

  Future<void> saveVitalsDraft(VitalsReading vitals);

  Future<Consultation> completeConsultation(VitalsReading vitals);
}

@LazySingleton(as: ConsultationRemoteDataSource)
class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ConsultationRemoteDataSourceImpl(this._firestore, this._auth);

  String get _doctorId => _auth.currentUser?.uid ?? AppConstants.demoDoctorId;

  /// The fixed demo patient this screen operates on — matches the id
  /// Patient Search/Details use for the same patient.
  static const String _patientId = 'patient-001';

  DocumentReference<Map<String, dynamic>> get _patientDoc => _firestore
      .collection(FirestorePaths.doctors)
      .doc(_doctorId)
      .collection('patients')
      .doc(_patientId);

  DocumentReference<Map<String, dynamic>> get _consultationDoc =>
      _patientDoc.collection('consultation').doc('active');

  /// The same patient identity record the referrals feature (DOC-06) owns
  /// — read as a fallback so a referred patient's name/status show up here
  /// immediately, even before this doctor-scoped chart has ever been
  /// written to.
  DocumentReference<Map<String, dynamic>> get _referralPatientDoc => _firestore
      .collection(FirestorePaths.patients)
      .doc(AppConstants.demoPatientId);

  PatientRecordStatus _statusFromCriticality(String criticality) =>
      switch (criticality.toLowerCase()) {
        'critical' => PatientRecordStatus.critical,
        'urgent' => PatientRecordStatus.urgent,
        'stable' => PatientRecordStatus.stable,
        'scheduled' => PatientRecordStatus.scheduled,
        _ => PatientRecordStatus.routine,
      };

  @override
  Future<Consultation> getActiveConsultation() async {
    try {
      final results = await Future.wait([
        _patientDoc.get(),
        _consultationDoc.get(),
      ]);
      final patientData = results[0].data() ?? const {};
      final sessionData = results[1].data() ?? const {};
      final referralData = patientData['name'] == null
          ? (await _referralPatientDoc.get()).data()
          : null;

      return Consultation(
        patient: _patientFromMap(patientData, referralData),
        session: ConsultationSession(
          doctorName: sessionData['doctorName'] as String? ?? '',
          visitType: sessionData['visitType'] as String? ?? '',
          startedAt: DateTime.fromMillisecondsSinceEpoch(
            (sessionData['startedAtMillis'] as num?)?.toInt() ??
                DateTime.now().millisecondsSinceEpoch,
          ),
        ),
        vitals: _vitalsFromMap(
          (sessionData['vitals'] as Map?) ?? const {},
        ),
      );
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not load the consultation.');
    }
  }

  @override
  Future<void> saveVitalsDraft(VitalsReading vitals) async {
    try {
      await _consultationDoc.set({
        'vitals': _vitalsToMap(vitals),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Could not save vitals.');
    }
  }

  @override
  Future<Consultation> completeConsultation(VitalsReading vitals) async {
    await saveVitalsDraft(vitals);
    return getActiveConsultation();
  }

  PatientRecord _patientFromMap(
    Map<String, dynamic> data,
    Map<String, dynamic>? referral,
  ) {
    final tags = ((data['tags'] as List?) ?? const []).cast<String>();
    final summary = referral?['summary'] as String?;

    return PatientRecord(
      id: _patientId,
      name: data['name'] as String? ?? referral?['name'] as String? ?? '',
      patientCode:
          data['patientCode'] as String? ?? referral?['displayId'] as String? ?? '',
      gender: data['gender'] as String? ?? '',
      age: (data['age'] as num?)?.toInt() ?? 0,
      location: data['location'] as String? ?? '',
      status: PatientRecordStatus.values.byName(
        data['status'] as String? ??
            (referral != null
                ? _statusFromCriticality(
                    referral['criticality'] as String? ?? '',
                  ).name
                : 'routine'),
      ),
      tags: tags.isNotEmpty
          ? tags
          : (summary != null && summary.isNotEmpty ? [summary] : const []),
      lastActivityLabel: data['lastActivityLabel'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> _vitalsToMap(VitalsReading vitals) => {
    'systolicBp': vitals.systolicBp,
    'diastolicBp': vitals.diastolicBp,
    'bloodGlucose': vitals.bloodGlucose,
    'pulseRate': vitals.pulseRate,
    'weightKg': vitals.weightKg,
    'temperatureC': vitals.temperatureC,
    'spo2': vitals.spo2,
  };

  VitalsReading _vitalsFromMap(Map<dynamic, dynamic> data) => VitalsReading(
    systolicBp: (data['systolicBp'] as num?)?.toInt(),
    diastolicBp: (data['diastolicBp'] as num?)?.toInt(),
    bloodGlucose: (data['bloodGlucose'] as num?)?.toDouble(),
    pulseRate: (data['pulseRate'] as num?)?.toInt(),
    weightKg: (data['weightKg'] as num?)?.toDouble(),
    temperatureC: (data['temperatureC'] as num?)?.toDouble(),
    spo2: (data['spo2'] as num?)?.toInt(),
  );
}
