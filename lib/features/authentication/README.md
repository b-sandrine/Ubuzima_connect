# authentication

Sign-up, login, session management, and role assignment (CHW / Doctor / Patient)
via Firebase Authentication + Firestore `users/{uid}` profiles.

Owns the `AuthSessionProvider` implementation consumed by `core/routing` for
auth guards. Session role is loaded from Firestore after sign-in and cached
locally for offline / onboarding.

Structure follows strict Clean Architecture:

```
data/
  datasources/local/    # role selection prefs
  datasources/remote/   # Firebase Auth + Firestore users
  models/
  repositories/
domain/
  entities/
  repositories/
  usecases/
presentation/
  bloc/
  pages/
  widgets/
```
