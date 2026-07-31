import 'package:equatable/equatable.dart';

/// A patient with active emergency screening flags for the CHW dashboard.
class ChwEmergencyAlert extends Equatable {
  final String patientId;
  final String patientName;
  final String location;
  final List<String> flags;
  final String riskLevel;

  const ChwEmergencyAlert({
    required this.patientId,
    required this.patientName,
    required this.location,
    required this.flags,
    required this.riskLevel,
  });

  String get flagsLabel => flags
      .map((f) {
        if (f.isEmpty) return f;
        final spaced = f.replaceAll('_', ' ');
        return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
      })
      .join(' · ');

  @override
  List<Object?> get props => [
    patientId,
    patientName,
    location,
    flags,
    riskLevel,
  ];
}

/// AI day summary plus concrete CHW action lines for the dashboard.
class ChwDayBriefing extends Equatable {
  final String summary;
  final List<String> recommendations;
  final bool fromAi;

  const ChwDayBriefing({
    required this.summary,
    required this.recommendations,
    this.fromAi = true,
  });

  @override
  List<Object?> get props => [summary, recommendations, fromAi];
}
