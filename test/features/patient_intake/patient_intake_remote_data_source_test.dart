import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/constants/firestore_paths.dart';
import 'package:ubuzima_connect/features/patient_intake/data/datasources/remote/patient_intake_remote_data_source.dart';
import 'package:ubuzima_connect/features/patient_intake/domain/entities/patient_intake_draft.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late FakeFirebaseFirestore firestore;
  late _MockFirebaseAuth auth;
  late _MockUser user;
  late PatientIntakeRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = _MockFirebaseAuth();
    user = _MockUser();
    when(() => user.uid).thenReturn('chw-1');
    when(() => auth.currentUser).thenReturn(user);
    dataSource = PatientIntakeRemoteDataSourceImpl(firestore, auth);
  });

  test('submit writes ownerId and nested identity for list queries', () async {
    final id = await dataSource.submitPatientIntake(
      const PatientIntakeDraft(
        fullName: 'Amina Uwase',
        gender: Gender.female,
        province: 'Kigali',
        district: 'Gasabo',
        primaryPhone: '0780000000',
      ),
    );

    final doc = await firestore
        .collection(FirestorePaths.patients)
        .doc(id)
        .get();
    final data = doc.data()!;

    expect(data['ownerId'], 'chw-1');
    expect(data['identity']['fullName'], 'Amina Uwase');
    expect(data['registeredAt'], isA<Timestamp>());
  });

  test('list returns intake patients and skips demo-shaped docs', () async {
    await firestore.collection(FirestorePaths.patients).doc('demo').set({
      'patientName': 'Marie Demo',
      'riskLevel': 'moderate',
    });
    await dataSource.submitPatientIntake(
      const PatientIntakeDraft(
        fullName: 'Jean Habimana',
        gender: Gender.male,
        district: 'Nyarugenge',
      ),
    );

    final patients = await dataSource.listRegisteredPatients();

    expect(patients.length, 1);
    expect(patients.first.fullName, 'Jean Habimana');
    expect(patients.first.district, 'Nyarugenge');
  });

  test('list can scope to the signed-in CHW via ownerId', () async {
    await dataSource.submitPatientIntake(
      const PatientIntakeDraft(fullName: 'Mine'),
    );
    await firestore.collection(FirestorePaths.patients).doc('other').set({
      'registeredAt': Timestamp.now(),
      'ownerId': 'someone-else',
      'identity': {'fullName': 'Other Patient'},
      'riskAssessment': {'score': 10, 'level': 'low'},
    });

    final mine = await dataSource.listRegisteredPatients(
      forCurrentUserOnly: true,
    );

    expect(mine.map((p) => p.fullName), ['Mine']);
  });
}
