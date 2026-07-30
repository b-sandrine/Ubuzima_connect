/// How serious an [Allergy] reaction is.
enum AllergySeverity { severe, moderate, mild }

/// One chip in the Allergies & Alerts panel.
class Allergy {
  final String label;
  final AllergySeverity severity;

  const Allergy({required this.label, required this.severity});
}
