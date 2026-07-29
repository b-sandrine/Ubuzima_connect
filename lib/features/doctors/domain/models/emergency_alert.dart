/// How urgently an [EmergencyAlert] needs the doctor's attention.
enum AlertSeverity { critical, urgent }

/// One entry in the dashboard's Emergency Alerts panel — a patient whose
/// vitals or results need immediate review.
class EmergencyAlert {
  final String id;
  final AlertSeverity severity;
  final String patientName;

  /// Where the patient is or what triggered the alert, e.g. "Ward 3B" or
  /// "Lab Results".
  final String location;
  final String description;

  const EmergencyAlert({
    required this.id,
    required this.severity,
    required this.patientName,
    required this.location,
    required this.description,
  });
}
