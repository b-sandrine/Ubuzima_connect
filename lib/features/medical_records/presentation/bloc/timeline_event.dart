part of 'timeline_bloc.dart';

/// The filter tabs across the top of DOC-04. Each maps to the set of event
/// categories it shows; [all] shows everything.
enum TimelineFilter {
  all('All Events'),
  visits('Visits'),
  diagnoses('Diagnoses'),
  medications('Medications'),
  labs('Labs');

  const TimelineFilter(this.label);

  final String label;

  /// The categories this tab admits. [all] returns an empty set, read as
  /// "no restriction".
  Set<EventCategory> get categories => switch (this) {
    TimelineFilter.all => const {},
    TimelineFilter.visits => const {EventCategory.visit},
    TimelineFilter.diagnoses => const {EventCategory.diagnosis},
    TimelineFilter.medications => const {EventCategory.prescription},
    TimelineFilter.labs => const {EventCategory.labResult},
  };

  bool admits(EventCategory category) =>
      categories.isEmpty || categories.contains(category);
}

@freezed
sealed class TimelineViewEvent with _$TimelineViewEvent {
  const factory TimelineViewEvent.started() = TimelineStarted;

  const factory TimelineViewEvent.filterChanged(TimelineFilter filter) =
      TimelineFilterChanged;

  const factory TimelineViewEvent.searchChanged(String query) =
      TimelineSearchChanged;
}
