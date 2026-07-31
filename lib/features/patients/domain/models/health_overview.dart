/// The headline "Health Score" ring + signal counts at the top of the AI
/// Insights screen — distinct from the dashboard's [HealthScore] card since
/// this view adds the signal/positive/watch breakdown, not just the score.
class HealthOverview {
  final int score;
  final int maxScore;
  final String statusLabel;
  final String trendLabel;
  final int signalsCount;
  final int positiveCount;
  final int watchCount;

  const HealthOverview({
    required this.score,
    required this.maxScore,
    required this.statusLabel,
    required this.trendLabel,
    required this.signalsCount,
    required this.positiveCount,
    required this.watchCount,
  });
}
