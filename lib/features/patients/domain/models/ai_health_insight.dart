/// The AI Health Insight card content — a generated observation surfaced to
/// the patient, e.g. a multi-day trend in a tracked vital.
class AiHealthInsight {
  final String title;
  final String tagLabel;
  final String message;
  final String updatedLabel;
  final String learnMoreLabel;

  const AiHealthInsight({
    required this.title,
    required this.tagLabel,
    required this.message,
    required this.updatedLabel,
    this.learnMoreLabel = 'Learn More',
  });
}
