import 'package:equatable/equatable.dart';

/// Overall risk banding for a patient, driving the header badge and the AI
/// assessment ring colour.
enum RiskLevel { low, moderate, high, critical }

/// How an active symptom is toned in the design — a caution (amber) or a
/// watch (blue) chip.
enum SymptomTone { caution, watch }

/// The kind of a next-step item, which sets its icon and accent colour.
enum NextStepKind { visit, check, referral }

/// The patient the CHW health record belongs to — the header card.
class HealthRecordPatient extends Equatable {
  final String name;
  final String demographics; // "Female · 28 years · Blood: O+"
  final RiskLevel riskLevel;
  final String recordId; // "RW-KGL-2025-04822"
  final String pregnancy; // "Pregnant · 24w" — empty when not applicable
  final String location; // "Gasabo, Kigali"
  final String insurance; // "Mutuelle"

  const HealthRecordPatient({
    required this.name,
    required this.demographics,
    required this.riskLevel,
    required this.recordId,
    required this.pregnancy,
    required this.location,
    required this.insurance,
  });

  @override
  List<Object?> get props => [
    name,
    demographics,
    riskLevel,
    recordId,
    pregnancy,
    location,
    insurance,
  ];
}

/// One labelled row in the Demographics card.
class DemographicRow extends Equatable {
  final String label;
  final String value;

  const DemographicRow(this.label, this.value);

  @override
  List<Object?> get props => [label, value];
}

/// The AI Health Assessment card.
class HealthAssessment extends Equatable {
  final int riskScore;
  final RiskLevel riskLevel;
  final String updatedLabel; // "Updated today"
  final String summary;
  final String keyRiskFactor;
  final String recommendation;

  const HealthAssessment({
    required this.riskScore,
    required this.riskLevel,
    required this.updatedLabel,
    required this.summary,
    required this.keyRiskFactor,
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
    riskScore,
    riskLevel,
    updatedLabel,
    summary,
    keyRiskFactor,
    recommendation,
  ];
}

/// A single symptom chip in Conditions & Symptoms.
class Symptom extends Equatable {
  final String label;
  final SymptomTone tone;

  const Symptom(this.label, this.tone);

  @override
  List<Object?> get props => [label, tone];
}

/// The Conditions & Symptoms card content.
class ConditionsSummary extends Equatable {
  final List<Symptom> activeSymptoms;
  final List<String> chronicConditions; // empty → "None Reported"
  final List<String> specialStatus; // e.g. "Pregnant · 24w", "COVID Vaccinated"

  const ConditionsSummary({
    required this.activeSymptoms,
    required this.chronicConditions,
    required this.specialStatus,
  });

  @override
  List<Object?> get props => [activeSymptoms, chronicConditions, specialStatus];
}

/// A single item in the Next Steps list.
class NextStep extends Equatable {
  final NextStepKind kind;
  final String title;
  final String detail;
  final String badge; // "3d", "Pending"

  const NextStep({
    required this.kind,
    required this.title,
    required this.detail,
    required this.badge,
  });

  @override
  List<Object?> get props => [kind, title, detail, badge];
}

/// Everything the CHW health record screen renders, loaded as one unit.
class HealthRecord extends Equatable {
  final String sector; // "CHW · Kigali Sector"
  final String dateLabel; // "Sunday, 01 Jun 2025"
  final HealthRecordPatient patient;
  final List<DemographicRow> demographics;
  final HealthAssessment assessment;
  final ConditionsSummary conditions;
  final List<NextStep> nextSteps;

  const HealthRecord({
    required this.sector,
    required this.dateLabel,
    required this.patient,
    required this.demographics,
    required this.assessment,
    required this.conditions,
    required this.nextSteps,
  });

  int get pendingCount => nextSteps.length;

  @override
  List<Object?> get props => [
    sector,
    dateLabel,
    patient,
    demographics,
    assessment,
    conditions,
    nextSteps,
  ];
}
