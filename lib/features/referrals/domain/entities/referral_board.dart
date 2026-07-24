import 'package:equatable/equatable.dart';

import 'referral.dart';

/// The patient the referral session is about — the chip under the header on
/// DOC-06.
class ReferralPatient extends Equatable {
  final String name;

  /// e.g. "RW-2847".
  final String id;

  /// e.g. "52F · HTN + T2DM + CKD".
  final String summary;

  /// "Critical", "Stable" … drives the badge colour.
  final String criticality;

  const ReferralPatient({
    required this.name,
    required this.id,
    required this.summary,
    required this.criticality,
  });

  @override
  List<Object?> get props => [name, id, summary, criticality];
}

/// Everything DOC-06 renders: the patient, and the referrals across the
/// three queues. Counts are derived so the tab badges and the pending
/// banner never drift from the list.
class ReferralBoard extends Equatable {
  final ReferralPatient patient;
  final List<Referral> referrals;

  const ReferralBoard({required this.patient, required this.referrals});

  List<Referral> forDirection(ReferralDirection direction) =>
      referrals.where((r) => r.direction == direction).toList();

  int pendingCount(ReferralDirection direction) => forDirection(direction)
      .where((r) => r.status == ReferralStatus.pending)
      .length;

  int urgentCount(ReferralDirection direction) => forDirection(direction)
      .where(
        (r) =>
            r.status == ReferralStatus.pending &&
            r.urgency == ReferralUrgency.urgent,
      )
      .length;

  ReferralBoard copyWith({List<Referral>? referrals}) =>
      ReferralBoard(patient: patient, referrals: referrals ?? this.referrals);

  @override
  List<Object?> get props => [patient, referrals];
}
