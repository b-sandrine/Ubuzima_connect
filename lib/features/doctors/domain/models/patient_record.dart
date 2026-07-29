/// A patient's current clinical status as shown on their record card.
enum PatientRecordStatus { critical, urgent, stable, scheduled, routine }

/// One entry in the doctor's Patient Search / recent patients list.
class PatientRecord {
  final String id;
  final String name;

  /// The hospital-assigned patient code, e.g. "RW-2847".
  final String patientCode;
  final String gender;
  final int age;

  /// Ward, department, or visit type, e.g. "Ward 3B" or "Maternity".
  final String location;
  final PatientRecordStatus status;

  /// Condition / follow-up tags shown as small chips, e.g. "Hypertension".
  final List<String> tags;

  /// Relative time since the last activity, e.g. "2h ago" or "Yesterday".
  final String lastActivityLabel;
  final String? photoUrl;

  const PatientRecord({
    required this.id,
    required this.name,
    required this.patientCode,
    required this.gender,
    required this.age,
    required this.location,
    required this.status,
    required this.tags,
    required this.lastActivityLabel,
    this.photoUrl,
  });
}
