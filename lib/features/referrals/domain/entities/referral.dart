import 'package:equatable/equatable.dart';

/// How quickly a referral needs action. Drives the badge colour and the
/// summary banner on DOC-06.
enum ReferralUrgency { urgent, pending, routine }

/// Which queue a referral sits in — the three tabs on DOC-06.
enum ReferralDirection { incoming, outgoing, followUp }

/// Where a referral is in its lifecycle. Accept/Decline move it off the
/// pending pile.
enum ReferralStatus { pending, accepted, declined }

/// A single referral in the doctor's queue. Mirrors the two cards on the
/// DOC-06 design (Cardiology / Ophthalmology) — identity, the clinical
/// narrative, the requested timeline, and the specialties it can be routed
/// to.
class Referral extends Equatable {
  /// Reference number shown on the card, e.g. "RW-REF-0041".
  final String reference;
  final String specialty;
  final ReferralUrgency urgency;
  final ReferralDirection direction;
  final ReferralStatus status;

  /// Originating facility badge, e.g. "CHC Kigali".
  final String facility;

  /// When it arrived, as a display label — "Received 08:22", "Yesterday".
  final String receivedLabel;

  final String referringPhysician;
  final String referringFacility;
  final String reason;

  /// Compact vitals line, e.g. "BP 158/96 mmHg · HR 88 bpm · eGFR 44".
  /// Null when the referral carries no structured summary.
  final String? clinicalSummary;

  /// Requested action window, e.g. "Within 48 hours".
  final String requestedTimeline;

  /// Whether the timeline should read as urgent (red) or relaxed (amber).
  final bool timelineIsUrgent;

  /// Specialties offered as routing chips under an incoming referral.
  final List<String> routeOptions;

  const Referral({
    required this.reference,
    required this.specialty,
    required this.urgency,
    required this.direction,
    required this.status,
    required this.facility,
    required this.receivedLabel,
    required this.referringPhysician,
    required this.referringFacility,
    required this.reason,
    required this.requestedTimeline,
    required this.timelineIsUrgent,
    this.clinicalSummary,
    this.routeOptions = const [],
  });

  Referral copyWith({ReferralStatus? status}) {
    return Referral(
      reference: reference,
      specialty: specialty,
      urgency: urgency,
      direction: direction,
      status: status ?? this.status,
      facility: facility,
      receivedLabel: receivedLabel,
      referringPhysician: referringPhysician,
      referringFacility: referringFacility,
      reason: reason,
      clinicalSummary: clinicalSummary,
      requestedTimeline: requestedTimeline,
      timelineIsUrgent: timelineIsUrgent,
      routeOptions: routeOptions,
    );
  }

  @override
  List<Object?> get props => [
    reference,
    specialty,
    urgency,
    direction,
    status,
    facility,
    receivedLabel,
    referringPhysician,
    referringFacility,
    reason,
    clinicalSummary,
    requestedTimeline,
    timelineIsUrgent,
    routeOptions,
  ];
}
