# settings

App preferences: language, theme, notification toggles, and account/session actions (logout, delete account).

Structure follows strict Clean Architecture:

```
data/
  datasources/local/    # sqflite queries
  datasources/remote/   # Firestore / Firebase Storage calls
  models/                 # Freezed + json_serializable, mapped to a domain Entity
  repositories/           # Implements the domain repository interface
domain/
  entities/               # Freezed, immutable, no serialization concerns
  repositories/           # Abstract interface — the contract Data must fulfill
  usecases/               # One class per business operation
presentation/
  bloc/                   # One Bloc per screen/interaction, not one giant feature Bloc
  pages/                  # Screen-level widgets, wired into core/routing
  widgets/                # Feature-local widgets not reused elsewhere
```

## Status

**SETTINGS-01 — Language** is delivered:
`presentation/pages/language_settings_page.dart` and
`presentation/widgets/language_option_card.dart`.

This screen has no `domain/`/`data/` of its own. Locale selection is
cross-cutting — the whole app's `MaterialApp` needs it, not just Settings —
so it was already implemented as `LocaleCubit` in `core/localization/`
(persisted through `LocalStorageService`/SharedPreferences, and provided
once above `MaterialApp` in `app.dart`). This page is presentation only: it
reads `LocaleCubit`'s state and calls `setLocale()` / `clear()`. If a future
screen needs the same locale info (e.g. a per-role home screen), it reads
the same cubit rather than this feature owning a duplicate copy.

Theme, notification toggles, and account actions (logout, delete account)
are not built yet.

