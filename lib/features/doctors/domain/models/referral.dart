/// Where a [Referral] stands in the receiving specialist's review.
enum ReferralStatus { pending, approved }

/// One entry in the doctor's Referral Status list.
class Referral {
  final String id;
  final String patientName;
  final String specialty;
  final String facility;
  final ReferralStatus status;

  /// The status footnote shown under the facility, e.g. "Sent 2 days ago"
  /// or "Confirmed".
  final String note;

  const Referral({
    required this.id,
    required this.patientName,
    required this.specialty,
    required this.facility,
    required this.status,
    required this.note,
  });
}
