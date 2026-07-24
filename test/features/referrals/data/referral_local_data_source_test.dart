import 'package:flutter_test/flutter_test.dart';
import 'package:ubuzima_connect/features/referrals/data/datasources/local/referral_local_data_source.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral.dart';
import 'package:ubuzima_connect/features/referrals/domain/entities/referral_draft.dart';

void main() {
  late ReferralLocalDataSourceImpl dataSource;

  setUp(() => dataSource = ReferralLocalDataSourceImpl());

  test('seeds all three queues so no tab is empty', () {
    final board = dataSource.readBoard();

    expect(board.forDirection(ReferralDirection.incoming), isNotEmpty);
    expect(board.forDirection(ReferralDirection.outgoing), isNotEmpty);
    expect(board.forDirection(ReferralDirection.followUp), isNotEmpty);
  });

  test('accept/decline flips the status in place', () {
    final incoming = dataSource
        .readBoard()
        .forDirection(ReferralDirection.incoming)
        .first;

    final accepted = dataSource.setStatus(
      incoming.reference,
      ReferralStatus.accepted,
    );

    expect(
      accepted.referrals
          .firstWhere((r) => r.reference == incoming.reference)
          .status,
      ReferralStatus.accepted,
    );
  });

  test('a created referral lands in the Outgoing queue', () {
    final before = dataSource
        .readBoard()
        .forDirection(ReferralDirection.outgoing)
        .length;

    final reference = dataSource.addReferral(
      const ReferralDraft(
        patientName: 'Jean Uwera',
        destinationFacility: 'CHUK',
        specialty: 'Emergency',
        urgency: ReferralUrgency.urgent,
        reason: 'Severe pre-eclampsia',
      ),
    );

    final outgoing = dataSource
        .readBoard()
        .forDirection(ReferralDirection.outgoing);

    expect(reference, startsWith('RW-REF-'));
    expect(outgoing.length, before + 1);
    expect(outgoing.any((r) => r.reference == reference), isTrue);
  });
}
