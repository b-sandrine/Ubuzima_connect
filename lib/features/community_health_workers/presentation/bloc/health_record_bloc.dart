import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/health_record.dart';
import '../../domain/usecases/complete_next_step.dart';
import '../../domain/usecases/get_health_record.dart';
import '../../domain/usecases/regenerate_ai_assessment.dart';

part 'health_record_bloc.freezed.dart';
part 'health_record_event.dart';
part 'health_record_state.dart';

/// Drives the CHW health record screen: loads the record, switches between the
/// Overview / Vitals / Visits / Immunization tabs, and completes next steps.
@injectable
class HealthRecordBloc extends Bloc<HealthRecordEvent, HealthRecordState> {
  final GetHealthRecord _getHealthRecord;
  final CompleteNextStep _completeNextStep;
  final RegenerateAiAssessment _regenerateAiAssessment;

  HealthRecordBloc(
    this._getHealthRecord,
    this._completeNextStep,
    this._regenerateAiAssessment,
  ) : super(const HealthRecordState()) {
    on<HealthRecordStarted>(_onStarted);
    on<HealthRecordTabChanged>(_onTabChanged);
    on<HealthRecordStepCompleted>(_onStepCompleted);
    on<HealthRecordAiAssessmentRequested>(_onAiAssessmentRequested);
  }

  Future<void> _onStarted(
    HealthRecordStarted event,
    Emitter<HealthRecordState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HealthRecordStatus.loading,
        patientId: event.patientId,
        errorMessage: null,
      ),
    );
    final result = await _getHealthRecord(patientId: event.patientId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HealthRecordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (record) => emit(
        state.copyWith(status: HealthRecordStatus.ready, record: record),
      ),
    );
  }

  void _onTabChanged(
    HealthRecordTabChanged event,
    Emitter<HealthRecordState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }

  Future<void> _onStepCompleted(
    HealthRecordStepCompleted event,
    Emitter<HealthRecordState> emit,
  ) async {
    final result = await _completeNextStep(
      event.stepId,
      patientId: state.patientId,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (record) => emit(state.copyWith(record: record, errorMessage: null)),
    );
  }

  Future<void> _onAiAssessmentRequested(
    HealthRecordAiAssessmentRequested event,
    Emitter<HealthRecordState> emit,
  ) async {
    if (state.isRefreshingAssessment) return;
    emit(state.copyWith(isRefreshingAssessment: true, errorMessage: null));
    final result = await _regenerateAiAssessment(patientId: state.patientId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isRefreshingAssessment: false,
          errorMessage: failure.message,
        ),
      ),
      (record) => emit(
        state.copyWith(
          isRefreshingAssessment: false,
          record: record,
          errorMessage: null,
        ),
      ),
    );
  }
}
