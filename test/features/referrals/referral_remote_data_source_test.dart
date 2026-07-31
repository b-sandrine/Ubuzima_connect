import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuzima_connect/features/referrals/data/datasources/local/referral_local_data_source.dart';
import 'package:ubuzima_connect/features/referrals/data/datasources/remote/referral_remote_data_source.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_draft.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

void main() {
  late FakeFirebaseFirestore firestore;
  late _MockFirebaseAuth auth;
  late ReferralRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = _MockFirebaseAuth();
    when(() => auth.currentUser).thenReturn(null);
    dataSource = ReferralRemoteDataSourceImpl(
      firestore,
      ReferralLocalDataSourceImpl(),
      auth,
    );
  });

  test('read seeds the demo board and returns the patient + referrals',
      () async {
    final board = await dataSource.readBoard();

    expect(board.patient.name, 'Marie Uwase');
    expect(board.referrals, isNotEmpty);
  });

  test('accept updates the referral status to accepted', () async {
    await dataSource.readBoard();

    final board = await dataSource.setStatus(
      'RW-REF-0041',
      ReferralStatus.accepted,
    );

    final referral = board.referrals.firstWhere(
      (r) => r.reference == 'RW-REF-0041',
    );
    expect(referral.status, ReferralStatus.accepted);
  });

  test('accept with a routed specialty re-routes the referral', () async {
    await dataSource.readBoard();

    final board = await dataSource.setStatus(
      'RW-REF-0041',
      ReferralStatus.accepted,
      routedSpecialty: 'Nephrology',
    );

    final referral = board.referrals.firstWhere(
      (r) => r.reference == 'RW-REF-0041',
    );
    expect(referral.specialty, 'Nephrology');
  });

  test('creating a referral adds it and returns a fresh reference', () async {
    await dataSource.readBoard();
    final before = (await dataSource.readBoard()).referrals.length;

    final reference = await dataSource.addReferral(
      const ReferralDraft(
        patientName: 'Marie Uwase',
        destinationFacility: 'CHUK',
        specialty: 'Cardiology',
        urgency: ReferralUrgency.urgent,
        reason: 'Chest pain on exertion.',
        clinicalSummary: 'BP 160/100',
        requestedTimeline: 'Within 48 hours',
      ),
    );

    final board = await dataSource.readBoard();
    expect(reference, startsWith('RW-REF-'));
    expect(board.referrals.length, before + 1);
    expect(
      board.referrals.any((r) => r.reference == reference),
      isTrue,
    );
  });

  test(
    'a new referral is tagged with the real signed-in doctor, not a placeholder',
    () async {
      final user = _MockUser();
      when(() => user.displayName).thenReturn('Dr. Jane Uwimana');
      when(() => auth.currentUser).thenReturn(user);

      final reference = await dataSource.addReferral(
        const ReferralDraft(
          patientName: 'Marie Uwase',
          destinationFacility: 'CHUK',
          specialty: 'Cardiology',
          urgency: ReferralUrgency.urgent,
          reason: 'Chest pain on exertion.',
        ),
      );

      final board = await dataSource.readBoard();
      final created = board.referrals.firstWhere(
        (r) => r.reference == reference,
      );
      expect(created.referringPhysician, 'Dr. Jane Uwimana');
    },
  );

  test('deleting a referral removes it from the board', () async {
    await dataSource.readBoard();

    final board = await dataSource.deleteReferral('RW-REF-0035');

    expect(
      board.referrals.any((r) => r.reference == 'RW-REF-0035'),
      isFalse,
    );
  });
}
