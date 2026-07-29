/// The dashboard's headline "Overall Health Score" gradient card content.
class HealthScore {
  final int score;
  final int maxScore;
  final String statusLabel;
  final String trendLabel;
  final String weeklyChangeLabel;

  const HealthScore({
    required this.score,
    required this.maxScore,
    required this.statusLabel,
    required this.trendLabel,
    required this.weeklyChangeLabel,
  });
}
