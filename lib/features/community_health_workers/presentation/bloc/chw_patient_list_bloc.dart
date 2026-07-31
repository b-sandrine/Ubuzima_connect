import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../patient_intake/domain/entities/registered_patient.dart';
import '../../../patient_intake/domain/usecases/list_registered_patients.dart';

part 'chw_patient_list_bloc.freezed.dart';
part 'chw_patient_list_event.dart';
part 'chw_patient_list_state.dart';

/// Loads and filters the CHW patient list from Firestore registrations.
@injectable
class ChwPatientListBloc
    extends Bloc<ChwPatientListEvent, ChwPatientListState> {
  final ListRegisteredPatients _listRegisteredPatients;

  ChwPatientListBloc(this._listRegisteredPatients)
    : super(const ChwPatientListState()) {
    on<ChwPatientListStarted>(_onStarted);
    on<ChwPatientListRefreshed>(_onRefreshed);
    on<ChwPatientListQueryChanged>(_onQueryChanged);
  }

  Future<void> _onStarted(
    ChwPatientListStarted event,
    Emitter<ChwPatientListState> emit,
  ) => _load(emit);

  Future<void> _onRefreshed(
    ChwPatientListRefreshed event,
    Emitter<ChwPatientListState> emit,
  ) => _load(emit);

  void _onQueryChanged(
    ChwPatientListQueryChanged event,
    Emitter<ChwPatientListState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _load(Emitter<ChwPatientListState> emit) async {
    emit(
      state.copyWith(
        status: ChwPatientListStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await _listRegisteredPatients();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChwPatientListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (patients) => emit(
        state.copyWith(
          status: ChwPatientListStatus.ready,
          patients: patients,
          errorMessage: null,
        ),
      ),
    );
  }
}
