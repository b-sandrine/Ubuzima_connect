import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/core/constants/app_constants.dart';
import 'package:ubuzima_connect/core/constants/firestore_paths.dart';
import 'package:ubuzima_connect/features/prescriptions/data/datasources/local/medication_local_data_source.dart';
import 'package:ubuzima_connect/features/prescriptions/data/datasources/remote/medication_remote_data_source.dart';
import 'package:ubuzima_connect/features/prescriptions/domain/entities/medication_dose.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MedicationRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = MedicationRemoteDataSourceImpl(
      firestore,
      MedicationLocalDataSourceImpl(),
    );
  });

  test('read seeds the demo patient on an empty project and returns it',
      () async {
    final schedule = await dataSource.readTodaySchedule();

    expect(schedule.summary.patientName, 'Marie Uwase');
    expect(schedule.doses, isNotEmpty);

    // The seed is persisted to Firestore, not just returned.
    final doc = await firestore
        .collection(FirestorePaths.prescriptions)
        .doc(AppConstants.demoPatientId)
        .get();
    expect(doc.exists, isTrue);
  });

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
