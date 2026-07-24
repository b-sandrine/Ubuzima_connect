import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_board.dart';
import '../../domain/usecases/accept_referral.dart';
import '../../domain/usecases/decline_referral.dart';
import '../../domain/usecases/get_referral_board.dart';

part 'referral_board_bloc.freezed.dart';
part 'referral_board_event.dart';
part 'referral_board_state.dart';

/// Drives the DOC-06 management board: loads the referral queues, switches
/// between Incoming / Outgoing / Follow-Up, and applies Accept / Decline —
/// each of which returns a fresh board so the counts and banners follow.
@injectable
class ReferralBoardBloc extends Bloc<ReferralBoardEvent, ReferralBoardState> {
  final GetReferralBoard _getReferralBoard;
  final AcceptReferral _acceptReferral;
  final DeclineReferral _declineReferral;

  ReferralBoardBloc(
    this._getReferralBoard,
    this._acceptReferral,
    this._declineReferral,
  ) : super(const ReferralBoardState()) {
    on<ReferralBoardStarted>(_onStarted);
    on<ReferralTabChanged>(_onTabChanged);
    on<ReferralAccepted>(_onAccepted);
    on<ReferralDeclined>(_onDeclined);
  }

  Future<void> _onStarted(
    ReferralBoardStarted event,
    Emitter<ReferralBoardState> emit,
  ) async {
    emit(state.copyWith(status: ReferralBoardStatus.loading));
    final result = await _getReferralBoard();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReferralBoardStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (board) => emit(
        state.copyWith(
          status: ReferralBoardStatus.ready,
          board: board,
          errorMessage: null,
        ),
      ),
    );
  }

  void _onTabChanged(
    ReferralTabChanged event,
    Emitter<ReferralBoardState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }

  Future<void> _onAccepted(
    ReferralAccepted event,
    Emitter<ReferralBoardState> emit,
  ) async {
    emit(state.copyWith(actioningReference: event.reference));
    final result = await _acceptReferral(
      event.reference,
      routedSpecialty: event.routedSpecialty,
    );
    _applyResult(result, emit);
  }

  Future<void> _onDeclined(
    ReferralDeclined event,
    Emitter<ReferralBoardState> emit,
  ) async {
    emit(state.copyWith(actioningReference: event.reference));
    final result = await _declineReferral(event.reference);
    _applyResult(result, emit);
  }

  void _applyResult(
    Either<Failure, ReferralBoard> result,
    Emitter<ReferralBoardState> emit,
  ) {
    result.fold(
      (failure) => emit(
        state.copyWith(
          actioningReference: null,
          errorMessage: failure.message,
        ),
      ),
      (board) => emit(
        state.copyWith(
          board: board,
          actioningReference: null,
          errorMessage: null,
        ),
      ),
    );
  }
}
