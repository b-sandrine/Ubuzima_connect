import 'package:equatable/equatable.dart';

import 'timeline_event.dart';

/// The patient the timeline belongs to — the header chip on DOC-04.
class TimelinePatient extends Equatable {
  final String name;
  final String summary;
  final String criticality;

  const TimelinePatient({
    required this.name,
    required this.summary,
    required this.criticality,
  });

  @override
  List<Object?> get props => [name, summary, criticality];
}

/// A single sample on the BP & Glucose trend chart. [systolic] and [glucose]
/// share an x-axis [label] (a month).
class TrendPoint extends Equatable {
  final String label;
  final double systolic;
  final double glucose;

  const TrendPoint({
    required this.label,
    required this.systolic,
    required this.glucose,
  });

  @override
  List<Object?> get props => [label, systolic, glucose];
}

/// Everything DOC-04 renders: the patient, the trend series, the full event
/// list, and the AI analysis paragraph.
class PatientTimeline extends Equatable {
  final TimelinePatient patient;
  final List<TrendPoint> trend;
  final List<TimelineEvent> events;
  final String aiSummary;

  const PatientTimeline({
    required this.patient,
    required this.trend,
    required this.events,
    required this.aiSummary,
  });

  int get eventCount => events.length;

  @override
  List<Object?> get props => [patient, trend, events, aiSummary];
}
