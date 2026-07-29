/// How soon a [QueuePatient] needs to be seen.
enum QueuePriority { urgent, moderate, routine }

/// One entry in the doctor's live Patient Queue.
class QueuePatient {
  final String id;
  final int queueNumber;
  final String name;

  /// The subtitle line shown under the name, e.g. "Chest pain" or
  /// "Fever, 38.9°C · 12 min wait".
  final String reason;
  final QueuePriority priority;
  final String? photoUrl;

  const QueuePatient({
    required this.id,
    required this.queueNumber,
    required this.name,
    required this.reason,
    required this.priority,
    this.photoUrl,
  });
}
