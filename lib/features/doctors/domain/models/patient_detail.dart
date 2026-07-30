import 'patient_record.dart';

/// The full clinical profile shown on the Patient Details screen — a richer
/// superset of the summary shown on a [PatientSearchScreen] result card.
class PatientDetail {
  final String id;
  final String name;
  final String patientCode;
  final String gender;
  final int age;

  /// Date of birth, formatted for display, e.g. "12 Mar 1972".
  final String dateOfBirth;
  final String location;
  final String hospital;
  final PatientRecordStatus status;
  final List<String> tags;
  final String? photoUrl;

  const PatientDetail({
    required this.id,
    required this.name,
    required this.patientCode,
    required this.gender,
    required this.age,
    required this.dateOfBirth,
    required this.location,
    required this.hospital,
    required this.status,
    required this.tags,
    this.photoUrl,
  });
}
