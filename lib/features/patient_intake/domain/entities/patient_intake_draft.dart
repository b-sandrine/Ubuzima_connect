import 'package:equatable/equatable.dart';

/// Gender captured on Step 1 — Personal Identity.
enum Gender { female, male }

/// Marital status captured on Step 2 — Demographics.
enum MaritalStatus { single, married, widowed }

/// Health insurance scheme captured on Step 2 — Demographics.
enum InsuranceType { mutuelle, private_, rssb, none }

/// Pregnancy status captured on Step 3 — Risk Screening.
enum PregnancyStatus { notPregnant, pregnant, unknown }

/// COVID-19 vaccination status captured on Step 3 — Risk Screening.
enum VaccinationStatus { fully, partial, none }

/// How long the reported symptoms have lasted, Step 3 — Current Symptoms.
enum SymptomDuration { underOneDay, oneToThreeDays, fourToSevenDays, overOneWeek }

/// A critical condition flagged by the CHW on Step 3 — Emergency Flags. Each
/// one immediately prioritizes the patient in the emergency alert system.
enum EmergencyFlag {
  unconscious,
  severeBreathingDifficulty,
  severeBleeding,
  highFever,
  convulsions,
  pregnancyEmergency,
}

/// Overall risk banding produced by [PatientRiskCalculator].
enum RiskLevel { low, moderate, high, critical }

/// The fixed symptom catalogue shown as toggle chips on Step 3. "None" is
/// mutually exclusive with every other entry.
abstract final class SymptomCatalogue {
  static const List<String> all = [
    'Fever',
    'Cough',
    'Fatigue',
    'Headache',
    'Nausea',
    'Diarrhea',
    'Chest Pain',
    'Breathless',
    'Swelling',
    'Rash / Skin',
    'Vomiting',
    'None',
  ];
}

/// The fixed chronic-condition catalogue shown as toggle chips on Step 3.
/// "None" is mutually exclusive with every other entry.
abstract final class ChronicConditionCatalogue {
  static const List<String> all = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'HIV/AIDS',
    'TB',
    'None',
  ];
}

/// The full payload built up across the three registration steps —
/// Identity & Household, Demographics & Contact, and Confirm & Submit. One
/// [PatientIntakeBloc] holds a single draft for the whole flow so nothing is
/// lost moving between steps.
class PatientIntakeDraft extends Equatable {
  // Step 1 — Personal Identity
  final String fullName;
  final String nationalId;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String identityPhone;

  // Step 1 — Household Details
  final String province;
  final String district;
  final String sector;
  final String cell;
  final String village;
  final int householdSize;
  final String headOfHousehold;
  final String ubudeheCategory;

  // Step 2 — Contact Information
  final String primaryPhone;
  final String alternatePhone;
  final String emergencyContactName;
  final String relationship;
  final String emergencyContactPhone;

  // Step 2 — Demographics
  final MaritalStatus? maritalStatus;
  final String educationLevel;
  final String occupation;
  final InsuranceType? insurance;
  final String insuranceNumber;

  // Step 2 — Location Details
  final String streetAddress;
  final String nearestLandmark;
  final bool gpsCaptured;

  // Step 2 — QR Identity Capture
  final bool qrCaptured;

  // Step 3 — Current Symptoms
  final SymptomDuration? symptomDuration;
  final Set<String> reportedSymptoms;
  final String additionalNotes;

  // Step 3 — Risk Screening
  final Set<String> chronicConditions;
  final PregnancyStatus? pregnancyStatus;
  final VaccinationStatus? vaccinationStatus;

  // Step 3 — Emergency Flags
  final Set<EmergencyFlag> emergencyFlags;

  const PatientIntakeDraft({
    this.fullName = '',
    this.nationalId = '',
    this.dateOfBirth,
    this.gender,
    this.identityPhone = '',
    this.province = '',
    this.district = '',
    this.sector = '',
    this.cell = '',
    this.village = '',
    this.householdSize = 1,
    this.headOfHousehold = '',
    this.ubudeheCategory = '',
    this.primaryPhone = '',
    this.alternatePhone = '',
    this.emergencyContactName = '',
    this.relationship = '',
    this.emergencyContactPhone = '',
    this.maritalStatus,
    this.educationLevel = '',
    this.occupation = '',
    this.insurance,
    this.insuranceNumber = '',
    this.streetAddress = '',
    this.nearestLandmark = '',
    this.gpsCaptured = false,
    this.qrCaptured = false,
    this.symptomDuration,
    this.reportedSymptoms = const {},
    this.additionalNotes = '',
    this.chronicConditions = const {},
    this.pregnancyStatus,
    this.vaccinationStatus,
    this.emergencyFlags = const {},
  });

  int? get age {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Step 1 gates on the fields the design marks with a red asterisk: full
  /// name, date of birth, gender, and the province/district/sector chain.
  bool get isIdentityStepComplete =>
      fullName.trim().isNotEmpty &&
      dateOfBirth != null &&
      gender != null &&
      province.trim().isNotEmpty &&
      district.trim().isNotEmpty &&
      sector.trim().isNotEmpty;

  /// Step 2 gates on the one required field the design marks: primary phone.
  bool get isContactStepComplete => primaryPhone.trim().isNotEmpty;

  /// Step 3 gates on symptom duration, the only required field on the
  /// confirm screen.
  bool get isSymptomsStepComplete => symptomDuration != null;

  PatientIntakeDraft copyWith({
    String? fullName,
    String? nationalId,
    DateTime? dateOfBirth,
    bool clearDateOfBirth = false,
    Gender? gender,
    String? identityPhone,
    String? province,
    String? district,
    String? sector,
    String? cell,
    String? village,
    int? householdSize,
    String? headOfHousehold,
    String? ubudeheCategory,
    String? primaryPhone,
    String? alternatePhone,
    String? emergencyContactName,
    String? relationship,
    String? emergencyContactPhone,
    MaritalStatus? maritalStatus,
    String? educationLevel,
    String? occupation,
    InsuranceType? insurance,
    String? insuranceNumber,
    String? streetAddress,
    String? nearestLandmark,
    bool? gpsCaptured,
    bool? qrCaptured,
    SymptomDuration? symptomDuration,
    Set<String>? reportedSymptoms,
    String? additionalNotes,
    Set<String>? chronicConditions,
    PregnancyStatus? pregnancyStatus,
    VaccinationStatus? vaccinationStatus,
    Set<EmergencyFlag>? emergencyFlags,
  }) {
    return PatientIntakeDraft(
      fullName: fullName ?? this.fullName,
      nationalId: nationalId ?? this.nationalId,
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      gender: gender ?? this.gender,
      identityPhone: identityPhone ?? this.identityPhone,
      province: province ?? this.province,
      district: district ?? this.district,
      sector: sector ?? this.sector,
      cell: cell ?? this.cell,
      village: village ?? this.village,
      householdSize: householdSize ?? this.householdSize,
      headOfHousehold: headOfHousehold ?? this.headOfHousehold,
      ubudeheCategory: ubudeheCategory ?? this.ubudeheCategory,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      relationship: relationship ?? this.relationship,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      educationLevel: educationLevel ?? this.educationLevel,
      occupation: occupation ?? this.occupation,
      insurance: insurance ?? this.insurance,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      streetAddress: streetAddress ?? this.streetAddress,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      gpsCaptured: gpsCaptured ?? this.gpsCaptured,
      qrCaptured: qrCaptured ?? this.qrCaptured,
      symptomDuration: symptomDuration ?? this.symptomDuration,
      reportedSymptoms: reportedSymptoms ?? this.reportedSymptoms,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
      vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
      emergencyFlags: emergencyFlags ?? this.emergencyFlags,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    nationalId,
    dateOfBirth,
    gender,
    identityPhone,
    province,
    district,
    sector,
    cell,
    village,
    householdSize,
    headOfHousehold,
    ubudeheCategory,
    primaryPhone,
    alternatePhone,
    emergencyContactName,
    relationship,
    emergencyContactPhone,
    maritalStatus,
    educationLevel,
    occupation,
    insurance,
    insuranceNumber,
    streetAddress,
    nearestLandmark,
    gpsCaptured,
    qrCaptured,
    symptomDuration,
    reportedSymptoms,
    additionalNotes,
    chronicConditions,
    pregnancyStatus,
    vaccinationStatus,
    emergencyFlags,
  ];
}

/// The auto-analyzed risk banding shown on Step 3 — computed client-side from
/// reported symptoms and chronic history, independent of the CHW's manual
/// Emergency Flags below it.
class RiskAssessment extends Equatable {
  final int score;
  final RiskLevel level;
  final String summary;

  const RiskAssessment({
    required this.score,
    required this.level,
    required this.summary,
  });

  @override
  List<Object?> get props => [score, level, summary];
}

/// Pure, deterministic stand-in for the design's "AI Risk Assessment" —
/// weights active symptoms and chronic conditions into a 0-100 score and a
/// short recommendation. Kept separate from Emergency Flags: those are a CHW
/// clinical override, not part of this auto-analysis.
abstract final class PatientRiskCalculator {
  static RiskAssessment calculate(PatientIntakeDraft draft) {
    final symptoms = draft.reportedSymptoms.where((s) => s != 'None').toList();
    final conditions = draft.chronicConditions
        .where((c) => c != 'None')
        .toList();

    var score = 15;
    score += symptoms.length * 9;
    score += conditions.length * 14;
    if (draft.pregnancyStatus == PregnancyStatus.pregnant) score += 10;
    score += switch (draft.vaccinationStatus) {
      VaccinationStatus.none => 10,
      VaccinationStatus.partial => 5,
      VaccinationStatus.fully || null => 0,
    };
    score = score.clamp(0, 100);

    final level = switch (score) {
      >= 80 => RiskLevel.critical,
      >= 55 => RiskLevel.high,
      >= 25 => RiskLevel.moderate,
      _ => RiskLevel.low,
    };

    final summary = _summarize(symptoms, conditions, level);
    return RiskAssessment(score: score, level: level, summary: summary);
  }

  static String _summarize(
    List<String> symptoms,
    List<String> conditions,
    RiskLevel level,
  ) {
    final symptomPart = symptoms.isEmpty
        ? 'No symptoms reported'
        : symptoms.length == 1
        ? symptoms.first
        : '${symptoms.take(2).join(' and ')}${symptoms.length > 2 ? ' and other symptoms' : ''}';
    final conditionPart = conditions.isEmpty
        ? 'no prior chronic conditions'
        : 'a history of ${conditions.join(', ')}';
    final recommendation = switch (level) {
      RiskLevel.low => 'Routine follow-up is sufficient.',
      RiskLevel.moderate => 'Consider follow-up within 3 days.',
      RiskLevel.high => 'Recommend follow-up within 24 hours.',
      RiskLevel.critical => 'Recommend immediate clinical review.',
    };
    return '$symptomPart combined with $conditionPart suggests '
        '${level.name} risk. $recommendation';
  }
}
