part of 'referral_board_bloc.dart';

@freezed
sealed class ReferralBoardEvent with _$ReferralBoardEvent {
  const factory ReferralBoardEvent.started() = ReferralBoardStarted;

  /// 0 = Incoming, 1 = Outgoing, 2 = Follow-Up.
  const factory ReferralBoardEvent.tabChanged(int index) = ReferralTabChanged;

  /// Accept a pending referral, optionally routing it to a chosen specialty.
  const factory ReferralBoardEvent.accepted(
    String reference, {
    String? routedSpecialty,
  }) = ReferralAccepted;

  const factory ReferralBoardEvent.declined(String reference) =
      ReferralDeclined;
}
