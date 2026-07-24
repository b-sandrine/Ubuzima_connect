import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/health_record.dart';
import '../../domain/usecases/get_health_record.dart';

part 'health_record_bloc.freezed.dart';
part 'health_record_event.dart';
part 'health_record_state.dart';

/// Drives the CHW health record screen: loads the record, then switches
/// between the Overview / Vitals / Visits / Immunization tabs.
@injectable
class HealthRecordBloc extends Bloc<HealthRecordEvent, HealthRecordState> {
  final GetHealthRecord _getHealthRecord;

  HealthRecordBloc(this._getHealthRecord) : super(const HealthRecordState()) {
    on<HealthRecordStarted>(_onStarted);
    on<HealthRecordTabChanged>(_onTabChanged);
  }

  Future<void> _onStarted(
    HealthRecordStarted event,
    Emitter<HealthRecordState> emit,
  ) async {
    emit(state.copyWith(status: HealthRecordStatus.loading));
    final result = await _getHealthRecord();
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
}
