part of 'referral_board_bloc.dart';

enum ReferralBoardStatus { initial, loading, ready, failure }

@freezed
abstract class ReferralBoardState with _$ReferralBoardState {
  const factory ReferralBoardState({
    @Default(ReferralBoardStatus.initial) ReferralBoardStatus status,
    ReferralBoard? board,
    @Default(0) int selectedTab,

    /// The reference currently being accepted/declined, so its card can show
    /// a spinner without freezing the rest of the list.
    String? actioningReference,
    String? errorMessage,
  }) = _ReferralBoardState;

  const ReferralBoardState._();

  ReferralDirection get direction => switch (selectedTab) {
    1 => ReferralDirection.outgoing,
    2 => ReferralDirection.followUp,
    _ => ReferralDirection.incoming,
  };

  /// Referrals for the currently selected tab.
  List<Referral> get visibleReferrals =>
      board?.forDirection(direction) ?? const [];
}
