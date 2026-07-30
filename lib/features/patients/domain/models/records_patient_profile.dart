import 'patient_tag.dart';

/// The patient identity header shown at the top of the Medical Records
/// screen — distinct from [PatientProfile] (the dashboard's lighter
/// greeting-strip identity) since this surface also carries clinical
/// summary tags (blood type, allergies, conditions).
class RecordsPatientProfile {
  final String fullName;
  final String displayId;
  final String dobLabel;
  final String? photoUrl;
  final bool verified;
  final List<PatientTag> tags;

  const RecordsPatientProfile({
    required this.fullName,
    required this.displayId,
    required this.dobLabel,
    this.photoUrl,
    this.verified = false,
    this.tags = const [],
  });
}
