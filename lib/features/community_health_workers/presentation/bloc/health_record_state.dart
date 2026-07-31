part of 'health_record_bloc.dart';

enum HealthRecordStatus { initial, loading, ready, failure }

@freezed
abstract class HealthRecordState with _$HealthRecordState {
  const factory HealthRecordState({
    @Default(HealthRecordStatus.initial) HealthRecordStatus status,
    HealthRecord? record,
    String? patientId,
    @Default(0) int selectedTab,
    @Default(false) bool isRefreshingAssessment,
    String? errorMessage,
  }) = _HealthRecordState;

  const HealthRecordState._();
}
