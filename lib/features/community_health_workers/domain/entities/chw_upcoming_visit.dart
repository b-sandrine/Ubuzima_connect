import 'package:equatable/equatable.dart';

/// A pending community visit derived from a patient's `next_steps` docs
/// (or a high-risk follow-up placeholder when no steps exist yet).
class ChwUpcomingVisit extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String type;
  final String timeLabel;
  final String detail;

  const ChwUpcomingVisit({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.type,
    required this.timeLabel,
    required this.detail,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    patientName,
    type,
    timeLabel,
    detail,
  ];
}
