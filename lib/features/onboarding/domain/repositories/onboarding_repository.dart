import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

/// Contract for persisting whether TUTORIAL-01 has been shown. Mirrors
/// `RoleSelectionRepository`'s shape: the flag lives on-device only, read
/// once at cold start to decide whether to show the tutorial before role
/// selection.
abstract interface class OnboardingRepository {
  Future<Either<Failure, bool>> isOnboardingComplete();

  Future<Either<Failure, Unit>> completeOnboarding();
}
