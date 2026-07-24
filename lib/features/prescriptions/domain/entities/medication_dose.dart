import 'package:equatable/equatable.dart';

/// Where a dose sits against its scheduled time today. Drives both the
/// trailing control (a green tick vs a "Take" button vs a time badge) and
/// the card's tint on PAT-03.
enum DoseStatus { taken, dueSoon, pending }

/// The part of day a dose belongs to. The schedule on PAT-03 is grouped
/// under Morning / Afternoon / Evening headers, each with its own summary
/// status pill.
enum DayPart { morning, afternoon, evening }

/// A small tag under a dose. Condition tags (Hypertension, Diabetes) carry a
/// clinical colour; instruction tags (With food, With water) are neutral.
enum DoseTagKind { condition, instruction }

class DoseTag extends Equatable {
  final String label;
  final DoseTagKind kind;

  const DoseTag(this.label, this.kind);

  const DoseTag.condition(this.label) : kind = DoseTagKind.condition;
  const DoseTag.instruction(this.label) : kind = DoseTagKind.instruction;

  @override
  List<Object?> get props => [label, kind];
}

/// A single scheduled intake of one medication today — the unit the Today
/// tab is built from.
class MedicationDose extends Equatable {
  final String id;
  final String name;

  /// Strength, e.g. "5mg".
  final String dosage;

  /// Amount to take, e.g. "1 tablet".
  final String amount;

  final DayPart dayPart;

  /// Clock label for the dose, e.g. "7:00 AM".
  final String timeLabel;

  /// Sub-line under the dosage — "Taken at 7:03 AM", "With lunch",
  /// "With dinner". Changes to a taken-at line once the dose is logged.
  final String instruction;

  final List<DoseTag> tags;
  final DoseStatus status;

  const MedicationDose({
    required this.id,
    required this.name,
    required this.dosage,
    required this.amount,
    required this.dayPart,
    required this.timeLabel,
    required this.instruction,
    required this.tags,
    required this.status,
  });

  MedicationDose copyWith({DoseStatus? status, String? instruction}) {
    return MedicationDose(
      id: id,
      name: name,
      dosage: dosage,
      amount: amount,
      dayPart: dayPart,
      timeLabel: timeLabel,
      instruction: instruction ?? this.instruction,
      tags: tags,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dosage,
    amount,
    dayPart,
    timeLabel,
    instruction,
    tags,
    status,
  ];
}
