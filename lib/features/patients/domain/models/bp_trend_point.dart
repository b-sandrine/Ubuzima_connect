/// One day's reading in the BP Trend · Last 7 Days chart.
class BpTrendPoint {
  final String dayLabel;
  final double systolic;
  final double diastolic;

  const BpTrendPoint({
    required this.dayLabel,
    required this.systolic,
    required this.diastolic,
  });
}
