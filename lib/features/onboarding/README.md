# onboarding

TUTORIAL-01 — the 3-slide swipeable intro shown once, before role
selection, explaining what the app does for a first-time user.

```
data/
  datasources/local/   # reads/writes StorageKeys.onboardingComplete via LocalStorageService
  repositories/         # OnboardingRepositoryImpl
domain/
  repositories/          # OnboardingRepository contract
  usecases/              # GetOnboardingComplete, CompleteOnboarding
presentation/
  bloc/                  # OnboardingCubit — plain hand-written state (no Freezed;
                          # a 2-field state class doesn't need an event union)
  pages/                 # OnboardingPage
  widgets/               # OnboardingSlideView (feature-local)
```

## Status: delivered, but not yet the automatic first-run screen

The screen itself works end-to-end — swipe through 3 slides, Skip/Get
Started both call `CompleteOnboarding` (persists
`StorageKeys.onboardingComplete = true`) and navigate to role selection.
It's reachable directly at `/onboarding`.

**What's still open:** it isn't wired to *automatically* appear on a
genuinely first cold start. That decision point is
`core/routing/route_guards.dart`, which currently sends every
unauthenticated user straight to role selection (AUTH-05). Making
onboarding the true entry point means checking
`GetOnboardingComplete`/`OnboardingLocalDataSource` there and redirecting
to `/onboarding` instead when it's false — see the `TODO` left in that
file for the exact hook point. I left this undone rather than changing
`AppRouter`'s constructor/DI wiring, since that intersects with the
auth-session work already in progress on AUTH-01–05.
