import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/core/constants/app_constants.dart';
import 'package:ubuzima_connect/core/constants/firestore_paths.dart';
import 'package:ubuzima_connect/features/prescriptions/data/datasources/local/medication_local_data_source.dart';
import 'package:ubuzima_connect/features/prescriptions/data/datasources/remote/medication_remote_data_source.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_dose.dart';

import '../../helpers/fake_clinical_ai_service.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late FakeFirebaseFirestore firestore;
  late _MockFirebaseAuth auth;
  late MedicationRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = _MockFirebaseAuth();
    when(() => auth.currentUser).thenReturn(null);
    dataSource = MedicationRemoteDataSourceImpl(
      firestore,
      MedicationLocalDataSourceImpl(),
      const FakeClinicalAiService(),
      auth,
    );
  });

  test('read seeds the demo patient on an empty project and returns it',
      () async {
    final schedule = await dataSource.readTodaySchedule();

    expect(schedule.summary.patientName, 'Marie Uwase');
    expect(schedule.doses, isNotEmpty);

    // With no signed-in user, the seed falls back to the demo patient id.
    final doc = await firestore
        .collection(FirestorePaths.prescriptions)
        .doc(AppConstants.demoPatientId)
        .get();
    expect(doc.exists, isTrue);
  });

  test(
    'a signed-in patient gets their own document, seeded under their real name',
    () async {
      final user = _MockUser();
      when(() => user.uid).thenReturn('patient-42');
      when(() => user.displayName).thenReturn('Jean Habimana');
      when(() => auth.currentUser).thenReturn(user);

      final schedule = await dataSource.readTodaySchedule();

      expect(schedule.summary.patientName, 'Jean Habimana');

      final demoDoc = await firestore
          .collection(FirestorePaths.prescriptions)
          .doc(AppConstants.demoPatientId)
          .get();
      expect(demoDoc.exists, isFalse);

      final ownDoc = await firestore
          .collection(FirestorePaths.prescriptions)
          .doc('patient-42')
          .get();
      expect(ownDoc.exists, isTrue);
      expect(ownDoc.data()?['patientName'], 'Jean Habimana');
    },
  );

  test('marking a due dose taken updates its status and adherence', () async {
    await dataSource.readTodaySchedule(); // seed

    final due = (await dataSource.readTodaySchedule()).doses.firstWhere(
      (d) => d.status == DoseStatus.dueSoon,
    );
    final before = await dataSource.readTodaySchedule();

    final after = await dataSource.markDoseTaken(due.id);

    final updated = after.doses.firstWhere((d) => d.id == due.id);
    expect(updated.status, DoseStatus.taken);
    expect(updated.instruction, contains('Taken'));
    expect(after.summary.takenToday, before.summary.takenToday + 1);
  });

  test('marking an already-taken dose is a no-op', () async {
    await dataSource.readTodaySchedule();
    final taken = (await dataSource.readTodaySchedule()).doses.firstWhere(
      (d) => d.status == DoseStatus.taken,
    );

    final before = await dataSource.readTodaySchedule();
    final after = await dataSource.markDoseTaken(taken.id);

    expect(after.summary.takenToday, before.summary.takenToday);
  });

  test('requesting a refill flips the refill flag in Firestore', () async {
    await dataSource.readTodaySchedule();

    final after = await dataSource.requestRefill();

    expect(after.refill?.requested, isTrue);
  });
}
