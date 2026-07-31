part of 'timeline_bloc.dart';

enum TimelineStatus { initial, loading, ready, failure }

@freezed
abstract class TimelineState with _$TimelineState {
  const factory TimelineState({
    @Default(TimelineStatus.initial) TimelineStatus status,
    PatientTimeline? timeline,
    @Default(TimelineFilter.all) TimelineFilter filter,
    @Default('') String query,
    @Default(false) bool earlierRevealed,
    String? errorMessage,
  }) = _TimelineState;

  const TimelineState._();

  /// Events after the active tab filter and search query, newest first
  /// (seed order is already chronological-descending).
  ///
  /// On the default "All Events" tab with no search, the oldest
  /// [PatientTimeline.earlierCount] events stay collapsed behind "Load
  /// Earlier Records" until requested — filtering or searching always
  /// searches the full history, since a hidden match would look like a bug.
  List<TimelineEvent> get visibleEvents {
    final all = timeline?.events ?? const <TimelineEvent>[];
    final windowed = _applyWindow(all);
    return windowed
        .where((e) => filter.admits(e.category) && e.matches(query))
        .toList();
  }

  List<TimelineEvent> _applyWindow(List<TimelineEvent> all) {
    if (earlierRevealed || filter != TimelineFilter.all || query.isNotEmpty) {
      return all;
    }
    final earlierCount = timeline?.earlierCount ?? 0;
    final windowSize = (all.length - earlierCount).clamp(0, all.length);
    return all.take(windowSize).toList();
  }

  /// Visible events grouped by year, preserving order, so the page can draw a
  /// year pill before each group.
  List<({int year, List<TimelineEvent> events})> get groupedByYear {
    final groups = <int, List<TimelineEvent>>{};
    final order = <int>[];
    for (final event in visibleEvents) {
      groups.putIfAbsent(event.year, () {
        order.add(event.year);
        return [];
      }).add(event);
    }
    return [
      for (final year in order) (year: year, events: groups[year]!),
    ];
  }
}
