part of 'medication_bloc.dart';

enum MedicationStatus { initial, loading, ready, failure }

@freezed
abstract class MedicationState with _$MedicationState {
  const factory MedicationState({
    @Default(MedicationStatus.initial) MedicationStatus status,
    MedicationSchedule? schedule,
    @Default(0) int selectedTab,
    String? errorMessage,
  }) = _MedicationState;

  const MedicationState._();

  /// Doses for the currently selected day, in schedule order. The design
  /// only fills the Today tab with content; the other tabs show an
  /// empty-state, so the page reads this straight through.
  List<MedicationDose> get doses => schedule?.doses ?? const [];
}
