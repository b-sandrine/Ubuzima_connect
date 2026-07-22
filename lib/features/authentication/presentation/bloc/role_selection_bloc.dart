import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_role.dart';
import '../../domain/usecases/get_selected_role.dart';
import '../../domain/usecases/save_selected_role.dart';

part 'role_selection_bloc.freezed.dart';
part 'role_selection_event.dart';
part 'role_selection_state.dart';

@injectable
class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  final GetSelectedRole _getSelectedRole;
  final SaveSelectedRole _saveSelectedRole;

  RoleSelectionBloc(this._getSelectedRole, this._saveSelectedRole)
    : super(const RoleSelectionState()) {
    on<RoleSelectionStarted>(_onStarted);
    on<RoleHighlighted>(_onRoleHighlighted);
    on<RoleSelectionConfirmed>(_onConfirmed);
  }

  Future<void> _onStarted(
    RoleSelectionStarted event,
    Emitter<RoleSelectionState> emit,
  ) async {
    final result = await _getSelectedRole();

    // A failed read is not worth blocking the screen on — the user can
    // simply pick again, so fall back to an empty selection.
    result.fold(
      (_) => emit(const RoleSelectionState()),
      (role) => emit(RoleSelectionState(highlightedRole: role)),
    );
  }

  void _onRoleHighlighted(
    RoleHighlighted event,
    Emitter<RoleSelectionState> emit,
  ) {
    emit(
      state.copyWith(
        status: RoleSelectionStatus.editing,
        highlightedRole: event.role,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onConfirmed(
    RoleSelectionConfirmed event,
    Emitter<RoleSelectionState> emit,
  ) async {
    final role = state.highlightedRole;
    if (role == null) return;

    emit(
      state.copyWith(
        status: RoleSelectionStatus.saving,
        destination: event.destination,
        errorMessage: null,
      ),
    );

    final result = await _saveSelectedRole(role);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RoleSelectionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: RoleSelectionStatus.saved)),
    );
  }
}
