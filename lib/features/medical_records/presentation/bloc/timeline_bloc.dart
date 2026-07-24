import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/patient_timeline.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/usecases/get_patient_timeline.dart';

part 'timeline_bloc.freezed.dart';
part 'timeline_event.dart';
part 'timeline_state.dart';

/// Drives DOC-04. Loads the timeline once, then filters it client-side by
/// category tab and free-text search — both cheap over a single patient's
/// history, and both keep the full list intact so clearing a filter is
/// instant.
@injectable
class TimelineBloc extends Bloc<TimelineViewEvent, TimelineState> {
  final GetPatientTimeline _getPatientTimeline;

  TimelineBloc(this._getPatientTimeline) : super(const TimelineState()) {
    on<TimelineStarted>(_onStarted);
    on<TimelineFilterChanged>(_onFilterChanged);
    on<TimelineSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(
    TimelineStarted event,
    Emitter<TimelineState> emit,
  ) async {
    emit(state.copyWith(status: TimelineStatus.loading));
    final result = await _getPatientTimeline();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TimelineStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (timeline) => emit(
        state.copyWith(
          status: TimelineStatus.ready,
          timeline: timeline,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onFilterChanged(
    TimelineFilterChanged event,
    Emitter<TimelineState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onSearchChanged(
    TimelineSearchChanged event,
    Emitter<TimelineState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }
}
