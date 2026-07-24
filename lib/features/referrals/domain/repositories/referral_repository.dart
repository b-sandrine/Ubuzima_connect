import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/referral_board.dart';
import '../entities/referral_draft.dart';

/// Contract for the referrals feature — the DOC-06 management board plus the
/// create flow shared with CHW-06b. Backed by a local mock today; the same
/// interface will front the referrals collection once it lands.
abstract interface class ReferralRepository {
  Future<Either<Failure, ReferralBoard>> getBoard();

  /// Accepts a pending referral, optionally routing it to [routedSpecialty].
  Future<Either<Failure, ReferralBoard>> acceptReferral(
    String reference, {
    String? routedSpecialty,
  });

  Future<Either<Failure, ReferralBoard>> declineReferral(String reference);

  /// Submits a new referral. Returns the reference number the system
  /// assigned, so the UI can confirm it to the user.
  Future<Either<Failure, String>> createReferral(ReferralDraft draft);
}
