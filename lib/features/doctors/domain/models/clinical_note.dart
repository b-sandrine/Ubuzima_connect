/// One entry in the Recent Clinical Notes timeline.
class ClinicalNote {
  final String id;
  final String authorName;
  final String authorRole;

  /// Relative time label, e.g. "Today", "Yesterday", "3 days ago".
  final String timeLabel;
  final String note;
  final List<String> tags;
  final String? authorPhotoUrl;

  const ClinicalNote({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timeLabel,
    required this.note,
    required this.tags,
    this.authorPhotoUrl,
  });
}
