/// Where a [ScheduleItem] sits relative to the current time.
enum ScheduleStatus {
  /// The appointment in progress right now.
  now,

  /// The next appointment coming up.
  next,

  /// Neither — shown with no status pill.
  none,
}

/// One entry in the doctor's Today's Schedule list.
class ScheduleItem {
  final String id;
  final String time;
  final String patientName;
  final String reason;
  final int durationMinutes;
  final ScheduleStatus status;

  const ScheduleItem({
    required this.id,
    required this.time,
    required this.patientName,
    required this.reason,
    required this.durationMinutes,
    this.status = ScheduleStatus.none,
  });
}
