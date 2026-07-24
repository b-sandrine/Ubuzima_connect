import 'package:injectable/injectable.dart';

import '../../../domain/entities/referral.dart';
import '../../../domain/entities/referral_board.dart';
import '../../../domain/entities/referral_draft.dart';

/// In-memory referrals store. Seeded to match the DOC-06 design (Marie
/// Uwase's Cardiology + Ophthalmology referrals) and mutated in place so
/// Accept / Decline / New survive within a session.
abstract interface class ReferralLocalDataSource {
  ReferralBoard readBoard();

  ReferralBoard setStatus(String reference, ReferralStatus status);

  /// Appends a new incoming referral built from [draft] and returns the
  /// reference the store assigned.
  String addReferral(ReferralDraft draft);
}

@LazySingleton(as: ReferralLocalDataSource)
class ReferralLocalDataSourceImpl implements ReferralLocalDataSource {
  ReferralBoard _board = _seed();
  int _sequence = 42;

  @override
  ReferralBoard readBoard() => _board;

  @override
  ReferralBoard setStatus(String reference, ReferralStatus status) {
    final updated = _board.referrals
        .map((r) => r.reference == reference ? r.copyWith(status: status) : r)
        .toList();
    _board = _board.copyWith(referrals: updated);
    return _board;
  }

  @override
  String addReferral(ReferralDraft draft) {
    final reference = 'RW-REF-${(_sequence++).toString().padLeft(4, '0')}';
    final referral = Referral(
      reference: reference,
      specialty: draft.specialty,
      urgency: draft.urgency,
      direction: ReferralDirection.outgoing,
      status: ReferralStatus.pending,
      facility: draft.destinationFacility,
      receivedLabel: 'Just now',
      referringPhysician: 'You',
      referringFacility: 'This facility',
      reason: draft.reason,
      clinicalSummary: draft.clinicalSummary.trim().isEmpty
          ? null
          : draft.clinicalSummary,
      requestedTimeline: draft.requestedTimeline.trim().isEmpty
          ? 'Not specified'
          : draft.requestedTimeline,
      timelineIsUrgent: draft.urgency == ReferralUrgency.urgent,
    );
    _board = _board.copyWith(referrals: [referral, ..._board.referrals]);
    return reference;
  }

  static ReferralBoard _seed() {
    return const ReferralBoard(
      patient: ReferralPatient(
        name: 'Marie Uwase',
        id: 'RW-2847',
        summary: '52F · HTN + T2DM + CKD',
        criticality: 'Critical',
      ),
      referrals: [
        Referral(
          reference: 'RW-REF-0041',
          specialty: 'Cardiology',
          urgency: ReferralUrgency.urgent,
          direction: ReferralDirection.incoming,
          status: ReferralStatus.pending,
          facility: 'CHC Kigali',
          receivedLabel: 'Received 08:22',
          referringPhysician: 'Dr. Nkurunziza Emmanuel',
          referringFacility: 'CHC Kigali',
          reason:
              'Hypertensive retinopathy Grade 2 + bilateral ankle oedema. '
              'Suspected early HF. Needs echo + cardiology specialist review.',
          clinicalSummary:
              'BP 158/96 mmHg · HR 88 bpm · eGFR 44 · HbA1c 9.1% · '
              'Retinopathy Grade 2',
          requestedTimeline: 'Within 48 hours',
          timelineIsUrgent: true,
          routeOptions: [
            'Cardiology',
            'Neurology',
            'Nephrology',
            'Ophthalmology',
          ],
        ),
        Referral(
          reference: 'RW-REF-0038',
          specialty: 'Ophthalmology',
          urgency: ReferralUrgency.pending,
          direction: ReferralDirection.incoming,
          status: ReferralStatus.pending,
          facility: 'CHUK',
          receivedLabel: 'Received Yesterday',
          referringPhysician: 'Dr. Mukamana Solange',
          referringFacility: 'CHUK',
          reason:
              'Diabetic retinopathy screening overdue. Last fundus exam 18 '
              'months ago. T2DM with poor glycaemic control (HbA1c 9.1%).',
          requestedTimeline: 'Within 4 weeks',
          timelineIsUrgent: false,
          routeOptions: ['Ophthalmology', 'Endocrinology'],
        ),
      ],
    );
  }
}
