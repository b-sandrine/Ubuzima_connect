/// The AI Clinical Insight card content — a generated observation surfaced
/// to the doctor, e.g. a follow-up gap across their patient panel.
class AiInsight {
  final String title;
  final String timestampLabel;
  final String message;

  const AiInsight({
    required this.title,
    required this.timestampLabel,
    required this.message,
  });
}
