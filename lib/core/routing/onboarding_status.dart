/// The `onboarding` feature owns the real completion flag. `core/routing`
/// depends only on this interface — never on the `onboarding` feature
/// directly — mirroring how `AuthSessionProvider` keeps routing decoupled
/// from `authentication`.
abstract interface class OnboardingStatusProvider {
  bool get isComplete;
}

/// Kept for unit tests that don't want local-storage wiring. The live
/// binding lives in `features/onboarding` as `OnboardingStatusProviderImpl`.
class NoOpOnboardingStatusProvider implements OnboardingStatusProvider {
  @override
  bool get isComplete => true;
}
