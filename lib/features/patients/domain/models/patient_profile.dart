/// The signed-in patient's identity strip shown at the top of the dashboard.
class PatientProfile {
  final String id;
  final String fullName;
  final String displayId;
  final String dateLabel;
  final String? photoUrl;
  final bool verified;

  const PatientProfile({
    required this.id,
    required this.fullName,
    required this.displayId,
    required this.dateLabel,
    this.photoUrl,
    this.verified = false,
  });
}
