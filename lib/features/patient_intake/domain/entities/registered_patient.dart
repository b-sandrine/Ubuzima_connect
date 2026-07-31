import 'package:equatable/equatable.dart';

import 'patient_intake_draft.dart';

/// A patient row returned by the registration list API — mapped from the
/// nested `patients/{id}` documents written by [submitPatientIntake].
class RegisteredPatient extends Equatable {
  final String id;
  final String fullName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? district;
  final String? province;
  final int riskScore;
  final RiskLevel riskLevel;
  final DateTime? registeredAt;

  const RegisteredPatient({
    required this.id,
    required this.fullName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.district,
    this.province,
    required this.riskScore,
    required this.riskLevel,
    this.registeredAt,
  });

  int? get ageYears {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  String get detailLine {
    final parts = <String>[];
    if (gender != null && gender!.isNotEmpty) {
      parts.add(_titleCase(gender!));
    }
    final age = ageYears;
    if (age != null) parts.add('${age}y');
    parts.add('Risk: ${_titleCase(riskLevel.name)}');
    return parts.join(' · ');
  }

  String get locationLabel {
    final parts = [
      if (district != null && district!.isNotEmpty) district!,
      if (province != null && province!.isNotEmpty) province!,
    ];
    return parts.join(', ');
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    gender,
    dateOfBirth,
    phone,
    district,
    province,
    riskScore,
    riskLevel,
    registeredAt,
  ];
}
