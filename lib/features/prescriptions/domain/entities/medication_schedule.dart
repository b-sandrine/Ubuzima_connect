import 'package:equatable/equatable.dart';

import 'medication_dose.dart';

/// The header card on PAT-03: who the schedule belongs to and the at-a-glance
/// adherence figures drawn in the green→blue gradient panel.
class MedicationSummary extends Equatable {
  final String patientName;

  /// Short condition line, e.g. "HTN · T2DM · 3 Active Prescriptions".
  final String conditionLine;
  final int adherencePercent;
  final int takenToday;
  final int totalToday;
  final int refillsDue;
  final int streakDays;

  const MedicationSummary({
    required this.patientName,
    required this.conditionLine,
    required this.adherencePercent,
    required this.takenToday,
    required this.totalToday,
    required this.refillsDue,
    required this.streakDays,
  });

  MedicationSummary copyWith({int? takenToday, int? adherencePercent}) {
    return MedicationSummary(
      patientName: patientName,
      conditionLine: conditionLine,
      adherencePercent: adherencePercent ?? this.adherencePercent,
      takenToday: takenToday ?? this.takenToday,
      totalToday: totalToday,
      refillsDue: refillsDue,
      streakDays: streakDays,
    );
  }

  @override
  List<Object?> get props => [
    patientName,
    conditionLine,
    adherencePercent,
    takenToday,
    totalToday,
    refillsDue,
    streakDays,
  ];
}

/// The amber refill-reminder banner. [requested] flips once the patient taps
/// Request, so the button can settle into a confirmed state.
class RefillReminder extends Equatable {
  final String medication;

  /// e.g. "5 tablets left · Runs out Jun 7".
  final String detail;
  final bool requested;

  const RefillReminder({
    required this.medication,
    required this.detail,
    this.requested = false,
  });

  RefillReminder copyWith({bool? requested}) => RefillReminder(
    medication: medication,
    detail: detail,
    requested: requested ?? this.requested,
  );

  @override
  List<Object?> get props => [medication, detail, requested];
}

/// Everything PAT-03 renders: the summary, the refill banner, today's doses,
/// and the AI insight footer. Loaded as one unit so the screen has a single
/// source of truth.
class MedicationSchedule extends Equatable {
  final MedicationSummary summary;
  final RefillReminder? refill;
  final String dateLabel;
  final List<MedicationDose> doses;

  /// The purple "AI Medication Insight" paragraph at the bottom.
  final String aiInsight;

  const MedicationSchedule({
    required this.summary,
    required this.refill,
    required this.dateLabel,
    required this.doses,
    required this.aiInsight,
  });

  MedicationSchedule copyWith({
    MedicationSummary? summary,
    RefillReminder? refill,
    List<MedicationDose>? doses,
  }) {
    return MedicationSchedule(
      summary: summary ?? this.summary,
      refill: refill ?? this.refill,
      dateLabel: dateLabel,
      doses: doses ?? this.doses,
      aiInsight: aiInsight,
    );
  }

  @override
  List<Object?> get props => [summary, refill, dateLabel, doses, aiInsight];
}
