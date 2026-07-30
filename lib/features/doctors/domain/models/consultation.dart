import 'package:equatable/equatable.dart';

import 'patient_record.dart';

/// The six vitals captured on the Consultation screen's Vitals tab. All
/// fields are optional until entered — `null` means "not recorded yet"
/// rather than zero.
class VitalsReading extends Equatable {
  final int? systolicBp;
  final int? diastolicBp;
  final double? bloodGlucose;
  final int? pulseRate;
  final double? weightKg;
  final double? temperatureC;
  final int? spo2;

  const VitalsReading({
    this.systolicBp,
    this.diastolicBp,
    this.bloodGlucose,
    this.pulseRate,
    this.weightKg,
    this.temperatureC,
    this.spo2,
  });

  static const int fieldCount = 6;

  int get filledCount => [
    systolicBp != null && diastolicBp != null,
    bloodGlucose != null,
    pulseRate != null,
    weightKg != null,
    temperatureC != null,
    spo2 != null,
  ].where((filled) => filled).length;

  bool get isComplete => filledCount == fieldCount;

  VitalsReading copyWith({
    int? systolicBp,
    int? diastolicBp,
    double? bloodGlucose,
    int? pulseRate,
    double? weightKg,
    double? temperatureC,
    int? spo2,
  }) {
    return VitalsReading(
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      bloodGlucose: bloodGlucose ?? this.bloodGlucose,
      pulseRate: pulseRate ?? this.pulseRate,
      weightKg: weightKg ?? this.weightKg,
      temperatureC: temperatureC ?? this.temperatureC,
      spo2: spo2 ?? this.spo2,
    );
  }

  @override
  List<Object?> get props => [
    systolicBp,
    diastolicBp,
    bloodGlucose,
    pulseRate,
    weightKg,
    temperatureC,
    spo2,
  ];
}

/// The session chrome around the vitals — who is seeing the patient, in what
/// setting, and since when (drives the live elapsed-time pill).
class ConsultationSession extends Equatable {
  final String doctorName;
  final String visitType;
  final DateTime startedAt;

  const ConsultationSession({
    required this.doctorName,
    required this.visitType,
    required this.startedAt,
  });

  @override
  List<Object?> get props => [doctorName, visitType, startedAt];
}

/// Everything the Consultation screen renders: the patient being seen, the
/// active session, and the vitals recorded so far.
class Consultation extends Equatable {
  final PatientRecord patient;
  final ConsultationSession session;
  final VitalsReading vitals;

  const Consultation({
    required this.patient,
    required this.session,
    required this.vitals,
  });

  Consultation copyWith({VitalsReading? vitals}) {
    return Consultation(
      patient: patient,
      session: session,
      vitals: vitals ?? this.vitals,
    );
  }

  @override
  List<Object?> get props => [patient, session, vitals];
}
