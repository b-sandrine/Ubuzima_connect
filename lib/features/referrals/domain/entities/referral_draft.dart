import 'package:equatable/equatable.dart';

import 'referral.dart';

/// The form payload for creating a referral — shared by the doctor's
/// "+ New" flow (DOC-06) and the CHW referral-to-hospital flow (CHW-06b).
class ReferralDraft extends Equatable {
  final String patientName;

  /// Destination facility, e.g. "CHUK", "Rwanda Military Hospital".
  final String destinationFacility;
  final String specialty;
  final ReferralUrgency urgency;
  final String reason;
  final String clinicalSummary;
  final String requestedTimeline;

  const ReferralDraft({
    this.patientName = '',
    this.destinationFacility = '',
    this.specialty = '',
    this.urgency = ReferralUrgency.routine,
    this.reason = '',
    this.clinicalSummary = '',
    this.requestedTimeline = '',
  });

  ReferralDraft copyWith({
    String? patientName,
    String? destinationFacility,
    String? specialty,
    ReferralUrgency? urgency,
    String? reason,
    String? clinicalSummary,
    String? requestedTimeline,
  }) {
    return ReferralDraft(
      patientName: patientName ?? this.patientName,
      destinationFacility: destinationFacility ?? this.destinationFacility,
      specialty: specialty ?? this.specialty,
      urgency: urgency ?? this.urgency,
      reason: reason ?? this.reason,
      clinicalSummary: clinicalSummary ?? this.clinicalSummary,
      requestedTimeline: requestedTimeline ?? this.requestedTimeline,
    );
  }

  /// A referral can be submitted once the essentials are present. Timeline
  /// and clinical summary are encouraged but not mandatory.
  bool get isComplete =>
      patientName.trim().isNotEmpty &&
      destinationFacility.trim().isNotEmpty &&
      specialty.trim().isNotEmpty &&
      reason.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    patientName,
    destinationFacility,
    specialty,
    urgency,
    reason,
    clinicalSummary,
    requestedTimeline,
  ];
}
