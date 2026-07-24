import 'package:equatable/equatable.dart';

/// The kind of clinical event on the DOC-04 timeline. Drives the node colour,
/// the category badge, and which filter tab an event falls under.
enum EventCategory {
  emergency,
  labResult,
  prescription,
  visit,
  diagnosis,
  referral,
}

/// One entry on the patient's chronological medical timeline.
class TimelineEvent extends Equatable {
  final String id;
  final EventCategory category;
  final String title;

  /// Display date, e.g. "1 Jun 2025".
  final String dateLabel;

  /// Grouping year — the timeline draws a year pill whenever this changes.
  final int year;

  /// The one/two-line clinical detail under the title.
  final String detail;

  const TimelineEvent({
    required this.id,
    required this.category,
    required this.title,
    required this.dateLabel,
    required this.year,
    required this.detail,
  });

  /// Whether this event matches a free-text search over title and detail.
  bool matches(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) || detail.toLowerCase().contains(q);
  }

  @override
  List<Object?> get props => [id, category, title, dateLabel, year, detail];
}
