import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/medication_dose.dart';
import '../../domain/entities/medication_schedule.dart';
import '../../domain/usecases/get_today_schedule.dart';
import '../../domain/usecases/mark_dose_taken.dart';
import '../../domain/usecases/request_refill.dart';

part 'medication_bloc.freezed.dart';
part 'medication_event.dart';
part 'medication_state.dart';

/// Drives PAT-03. Loads today's schedule, then handles the two mutations the
/// screen offers — logging a dose (the "Take" button) and requesting a
/// refill — each of which returns a fresh schedule the view rebuilds from.
@injectable
class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final GetTodaySchedule _getTodaySchedule;
  final MarkDoseTaken _markDoseTaken;
  final RequestRefill _requestRefill;

  MedicationBloc(
    this._getTodaySchedule,
    this._markDoseTaken,
    this._requestRefill,
  ) : super(const MedicationState()) {
    on<MedicationStarted>(_onStarted);
    on<MedicationTabChanged>(_onTabChanged);
    on<DoseMarkedTaken>(_onDoseMarkedTaken);
    on<RefillRequested>(_onRefillRequested);
  }

  Future<void> _onStarted(
    MedicationStarted event,
    Emitter<MedicationState> emit,
  ) async {
    emit(state.copyWith(status: MedicationStatus.loading));
    final result = await _getTodaySchedule();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MedicationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (schedule) => emit(
        state.copyWith(
          status: MedicationStatus.ready,
          schedule: schedule,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onTabChanged(
    MedicationTabChanged event,
    Emitter<MedicationState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }

  Future<void> _onDoseMarkedTaken(
    DoseMarkedTaken event,
    Emitter<MedicationState> emit,
  ) async {
    final result = await _markDoseTaken(event.doseId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (schedule) =>
          emit(state.copyWith(schedule: schedule, errorMessage: null)),
    );
  }

  Future<void> _onRefillRequested(
    RefillRequested event,
    Emitter<MedicationState> emit,
  ) async {
    final result = await _requestRefill();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (schedule) =>
          emit(state.copyWith(schedule: schedule, errorMessage: null)),
    );
  }
}
