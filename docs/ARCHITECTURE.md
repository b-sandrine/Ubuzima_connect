# Ubuzima Connect — Architecture

Enterprise, offline-first healthcare platform for Rwanda connecting Community Health
Workers (CHWs), Doctors, and Patients. This document is Phase 1 of the foundation
build: the folder structure, the reasoning behind it, and known scalability
trade-offs to revisit as the app grows past 100 screens.

## 1. Layering rules

```
Presentation → Domain → Data → Core
```

- **Domain has zero Flutter/Firebase/SQLite imports.** It is pure Dart: entities,
  repository *interfaces*, use cases. This is what makes business rules testable
  without a widget tree or a database.
- **Presentation depends only on Domain** (entities + use cases via Bloc). It never
  imports anything from `data/` — no models, no Firestore document snapshots, no
  sqflite rows leak into a widget or a Bloc state.
- **Data implements Domain's repository interfaces.** It owns Models
  (Freezed + json_serializable, Firestore/SQLite (de)serialization) and Mappers that
  convert Model ↔ Entity at the boundary. This is the Dependency Inversion
  Principle in practice: Domain defines the contract, Data fulfills it, and Domain
  never imports Data.
- **Core is the only thing every layer may depend on** — it has no feature
  knowledge. It supplies cross-cutting infrastructure (DI, routing, theming,
  database handles, network/connectivity, error types, logging, security).

Enforcement isn't just convention here: `analysis_options.yaml` should eventually
grow a lint (or a CI script using `import_lint`/`dart_dependency_validator`) that
fails the build if `features/*/presentation` imports anything from
`features/*/data`. That's flagged below as a Phase 3 follow-up.

## 2. Top-level `lib/` layout

```
lib/
├── main.dart              # Entry point — flavors could split this later
├── bootstrap.dart          # Firebase/Hive/DI/error-zone bring-up before runApp
├── app.dart                # MaterialApp.router + theme + localization wiring
├── core/                   # Cross-cutting infrastructure (feature-agnostic)
├── shared/                 # Cross-cutting *presentation* (reusable widgets)
├── features/               # One folder per bounded context (see §4)
└── l10n/                   # ARB translation sources (en, rw, fr)
```

`bootstrap.dart` is split out from `main.dart` deliberately: it's the seam where
Sentry/Crashlytics zone wrapping, `WidgetsFlutterBinding`, Firebase init, Hive/SQLite
init, and `configureDependencies()` happen — before a single widget is built. This
keeps `main.dart` a one-line file and makes it trivial to add
`main_staging.dart` / `main_production.dart` entry points later without duplicating
bring-up logic.

## 3. `core/` — explained folder by folder

| Folder | Responsibility |
|---|---|
| `constants/` | App-wide literals: `app_constants.dart` (app name, timeouts), `storage_keys.dart` (SharedPreferences/SecureStorage key names — centralized so a typo can't silently create a second key), `firestore_paths.dart` (collection name constants, one source of truth for every Firestore path used across features). |
| `routing/` | `app_router.dart` (the single `GoRouter` instance), `app_routes.dart` (route name/path constants), `route_guards.dart` (auth + role redirect logic). Each feature owns its own route *definitions*; this folder only aggregates them and applies cross-cutting guards. |
| `theme/` | `app_theme.dart` (light/dark `ThemeData`, Material 3), `app_colors.dart` (healthcare palette), `app_text_styles.dart`, `app_spacing.dart`/`app_radius.dart` design tokens. |
| `extensions/` | `context_extensions.dart` (`context.theme`, `context.l10n`), `string_extensions.dart`, `datetime_extensions.dart`, `num_extensions.dart`. Small, pure, no side effects. |
| `network/` | `network_info.dart` (Connectivity abstraction used by every repository to pick Local vs Remote), future `dio_client.dart` for any external REST call (e.g. geocoding, SMS gateway). |
| `errors/` | `Failure` hierarchy (`ServerFailure`, `CacheFailure`, `NetworkFailure`, `SyncConflictFailure`, `ValidationFailure`) — `Equatable`, returned by every repository as `Either<Failure, T>`. This is what Presentation actually switches on; it never sees a raw exception. |
| `exceptions/` | Low-level throwables (`ServerException`, `CacheException`, `AuthException`) thrown by data sources and caught at the repository boundary, where they're translated into the `Failure`s above. Keeping exceptions and failures in separate folders enforces the translation step instead of letting a Firestore exception leak into the UI. |
| `validators/` | Pure functions: `email_validator.dart`, `phone_validator.dart` (Rwandan phone formats), `required_validator.dart`, composable for form fields across every feature. |
| `helpers/` | Stateless utilities that don't fit elsewhere: `id_generator.dart` (UUID for offline-created records), `date_formatter.dart`, `debouncer.dart`. |
| `services/` | Cross-feature *stateful* services that aren't pure infra: `connectivity_service.dart` (stream of online/offline), `sync_service.dart` (interface only — real engine lives in `features/offline_sync`), `firebase_messaging_service.dart`. |
| `permissions/` | `permission_service.dart` wrapping `permission_handler` for location/camera/notification runtime permissions, with typed results instead of raw platform strings. |
| `database/` | `app_database.dart` (sqflite open/upgrade lifecycle), `database_tables.dart` (table name + column constants, one per feature so migrations don't collide), `migrations/` folder for versioned schema upgrades. |
| `storage/` | `local_storage_service.dart` (SharedPreferences wrapper for non-sensitive key/value), `secure_storage_service.dart` (flutter_secure_storage for tokens). |
| `logging/` | `app_logger.dart` — one logging facade so a future switch to Crashlytics/Sentry touches one file, not 100 call sites. |
| `analytics/` | `analytics_service.dart` interface + Firebase Analytics implementation, injected so screens log events without knowing the provider. |
| `localization/` | `l10n` generation config glue and `locale_extensions.dart`; the ARB sources themselves live in `lib/l10n/`. |
| `security/` | Token/session helpers, encryption utilities for anything cached locally (e.g. encrypting the SQLite DB key), input sanitization helpers. |
| `di/` | `injection.dart` (`@InjectableInit` entry point + `configureDependencies()`), `injection.config.dart` (generated). Per-feature DI modules live inside each feature (`features/<x>/<x>_injection_module.dart`) and are picked up automatically by Injectable's annotation scan — see §6. |

## 4. `shared/` — reusable presentation

`shared/widgets/` holds Flutter widgets with **no Bloc, no feature import, no
business logic** — pure presentation building blocks any feature can compose:

`buttons/`, `cards/`, `dialogs/`, `inputs/`, `medical/` (vital-sign tiles, risk
badges, patient summary cards — domain-flavored but still just presentation),
`status_chips/`, `avatar/`, `loading/`, `error/`, `forms/`, `navigation/`,
`app_bars/`, `bottom_sheets/`, `charts/`.

Rule of thumb for "does this belong in `shared/` or in a feature's own
`presentation/widgets/`?": if two or more features would import it, it's shared;
if it's specific to one feature's screen, it stays local to that feature.

## 5. `features/` — the 14 bounded contexts

```
authentication · users · patients · community_health_workers · doctors
medical_records · risk_assessment · appointments · prescriptions · referrals
notifications · location · offline_sync · settings
```

Every feature is a self-contained Clean Architecture slice:

```
features/<feature>/
├── data/
│   ├── datasources/
│   │   ├── local/       # sqflite queries — implements <X>LocalDataSource
│   │   └── remote/      # Firestore/Storage calls — implements <X>RemoteDataSource
│   ├── models/           # Freezed + json_serializable, extends/maps to an Entity
│   └── repositories/     # <X>RepositoryImpl — decides local vs remote, merges,
│                         # resolves conflicts, implements the Domain interface
├── domain/
│   ├── entities/         # Freezed, immutable, no serialization concerns
│   ├── repositories/     # Abstract interface — the contract Data must fulfill
│   └── usecases/         # One class per business operation (`GetPatientRecord`,
│                         # `SubmitRiskAssessment`) — Presentation only ever calls
│                         # a use case, never a repository directly
└── presentation/
    ├── bloc/             # <X>Bloc + <X>Event + <X>State, one Bloc per screen
                            # or per cohesive interaction, not one giant feature Bloc
    ├── pages/             # Screen-level widgets, wired to routing
    └── widgets/           # Feature-local widgets not reused elsewhere
```

### Why these 14, and not a `pharmacy` module

The spec is explicit that Ubuzima Connect does not manage pharmacies as
first-class entities. "Find Medicine" is a *capability* of the Prescription
module, powered by the Location module:

- **`prescriptions`** owns the prescription entity, the doctor-writes /
  patient-views lifecycle, and the "Find Medicine" trigger.
- **`location`** owns Google Maps, GPS, nearby-pharmacy search, distance/ETA
  calculation, and (future) directions. It has no idea what a prescription is —
  it just answers "where can I find X near this point, sorted by distance /
  open-now / likely availability."

This keeps pharmacy-search reusable (Location could later serve lab locators,
CHW-visit routing, doctor clinic locators) instead of being buried inside a
one-off Pharmacy module, and it keeps Prescriptions from importing Maps/GPS
concerns it doesn't own.

### Why `offline_sync` is its own feature, not part of `core`

Sync *policy* (what to queue, retry backoff, conflict resolution rules like
last-write-wins vs. field-level merge for a medical record) is business logic
that differs per entity and will grow — a CHW's offline vitals entry conflicts
differently than a doctor's offline prescription edit. That belongs in a
feature with its own domain layer (`SyncQueue` entity, `ResolveConflict`
use case), not buried in `core/services`. `core` only provides the generic
plumbing (`NetworkInfo`, the sqflite handle); `offline_sync` provides the
domain rules for what to do with that plumbing. Every other feature's
repository depends on `offline_sync`'s domain interfaces to enqueue writes —
not the other way around, so the dependency still points inward.

## 6. Dependency Injection (GetIt + Injectable)

- `core/di/injection.dart` exposes `configureDependencies()`, called once from
  `bootstrap.dart`.
- Instead of one 500-line hand-written registration file, every injectable class
  is annotated in place (`@LazySingleton`, `@injectable`, `@module`) and
  `build_runner` aggregates all of them into a single generated
  `injection.config.dart`. Registrations are physically decentralized (they live
  next to the class they register) even though the generated output is one file.
- Any binding that needs manual wiring (e.g. `FirebaseFirestore.instance`,
  `sqflite`'s `Database` singleton, `Dio` with interceptors) is declared in a
  small `@module` abstract class inside `core/di/register_modules.dart` or the
  owning feature — never in a shared god-file.

## 7. Routing (GoRouter)

- `core/routing/app_router.dart` builds one `GoRouter` from a list of
  `RouteBase` contributed by each feature (`features/<x>/<x>_routes.dart`),
  keeping route ownership with the feature while keeping a single router
  instance for deep-linking.
- `route_guards.dart` implements `redirect:` logic: unauthenticated →
  `/login`; authenticated but wrong role for a route (e.g. a Patient hitting a
  CHW-only path) → role-appropriate home.
- Deep links (e.g. a push notification opening a specific appointment) resolve
  through the same route table, so no parallel navigation stack exists.

## 8. Offline-first data flow

Every feature repository follows the same shape:

1. Check `NetworkInfo` (from `core/network`).
2. **Writes** always go to SQLite first and are enqueued via
   `offline_sync`'s `SyncQueueRepository`; the UI never blocks on network.
3. **Reads** prefer local cache; if online and cache is stale, fetch Firestore
   and rehydrate SQLite.
4. A background isolate/worker (owned by `offline_sync`) drains the queue when
   `NetworkInfo` reports connectivity, applies conflict resolution, and updates
   both SQLite and Firestore.

This means an individual feature's repository never talks to Firestore
directly for writes — it always goes through the local-first path, which is
what makes "must function completely offline" true by construction rather than
by discipline.

## 9. State management conventions

- One Bloc per cohesive screen/interaction — not one Bloc per feature. E.g.
  `patients` will eventually have `PatientListBloc`, `PatientDetailBloc`,
  `PatientFormBloc`, not a single `PatientsBloc` handling everything.
- Events and States are `Freezed` sealed unions so `when`/`map` gives
  exhaustiveness checking at compile time.
- Blocs depend only on Use Cases (Domain), never on repositories or data
  sources directly — this is what keeps them unit-testable with fakes.

## 10. Testing layout

```
test/
├── core/            # mirrors lib/core
├── shared/           # widget tests for reusable components
└── features/<x>/
    ├── data/          # datasource + repository tests (fake local/remote)
    ├── domain/        # usecase tests (fake repository)
    └── presentation/  # bloc_test-driven Bloc tests

integration_test/       # full-app flows (Flutter's standard top-level convention)
```

## 11. Known scalability risks at 100+ screens (flag now, revisit in Phase 3)

1. **Bloc-per-screen sprawl.** At 100+ screens this could mean 150+ Blocs. Worth
   introducing a shared `BaseBloc`/`BaseState` convention early (loading /
   success / failure shape) so every Bloc is structurally predictable and a
   codegen snippet (`plugin` or `mason` brick) can scaffold new ones
   consistently instead of copy-paste drift.
2. **GoRouter route table growth.** A single flat `routes` list contributed by
   14+ features will get unwieldy. Recommend each feature expose a
   `GoRoute`-returning function and `app_router.dart` simply concatenates them —
   already planned above — but add a naming convention
   (`/patients/:id/records`) enforced via a lint or test that walks
   `app_router` and asserts no path collisions.
3. **Firestore collection/document shape drift.** With 14 features each owning
   Firestore paths, without `core/constants/firestore_paths.dart` as the *only*
   place literal collection names appear, typos will fragment data silently.
   This is why that file is called out explicitly above — treat it as
   non-negotiable from day one.
4. **SQLite migrations across many feature tables.** A single `onUpgrade`
   growing forever is a maintenance hazard. Recommend a numbered
   `migrations/000x_description.dart` file per schema change from the very
   first migration, applied in order, rather than one growing switch statement.
5. **Injectable's single generated config file.** At 100+ screens the generated
   `injection.config.dart` becomes very large (this is fine — it's generated,
   not hand-maintained) but full-project `build_runner` rebuilds will slow down.
   Watch for this and consider `build_runner build --build-filter` scoping or
   splitting generation per package if the monorepo grows into melos packages
   (see next point).
6. **Long-term: consider a Melos monorepo.** Not needed at foundation stage,
   but if `core`/`shared` stabilize and multiple apps (e.g. a separate CHW-only
   build) ever share them, promoting `core` and `shared` to standalone local
   packages (via Melos) prevents a single monolithic `lib/` from becoming the
   bottleneck. Flagged as a future improvement, not part of this foundation.
7. **Role-based navigation complexity.** Three roles (CHW / Doctor / Patient)
   sharing one route table will accumulate `if (role == ...)` branching inside
   guards. Recommend each role eventually get its own shell route
   (`StatefulShellRoute`) with its own bottom-navigation, rather than branching
   inside a flat route list — flagged for when the first real screens land.

## 12. Suggested near-term improvements (not blocking foundation)

- Add an import-boundary lint (custom `dart_dependency_validator` config or a
  small `test/architecture_test.dart` that greps for illegal
  `presentation → data` imports) so Clean Architecture violations fail CI
  instead of relying on code review.
- Add a `mason` brick (or plain code snippet) for "new feature" and "new Bloc"
  scaffolding once the first 2–3 real features are built, so the pattern is
  extracted from real usage rather than guessed upfront.
- Decide early whether Freezed unions or plain sealed classes are used for
  Bloc events/states (this foundation uses Freezed, per the requested stack)
  and document it so all 14 features stay consistent.

## 13. Phase 3 review notes

The foundation was verified end-to-end: `flutter analyze` is clean, `flutter
test` passes, `dart run build_runner build` generates DI wiring and
`flutter build web --debug` compiles the full app (Firebase init, routing,
theming, localization). Three things to revisit before shipping real
features, flagged here rather than silently left in the codebase:

1. **`freezed` is pinned to `3.2.6-dev.1`.** At the time this foundation was
   built, no stable `freezed` 3.x release existed that was simultaneously
   compatible with `injectable_generator` 3.x's `analyzer` requirement and
   `bloc_test`'s transitive `test`/`analyzer` constraints — every stable
   combination the resolver tried conflicted. Re-run `flutter pub outdated`
   periodically and move off the prerelease the moment a stable line
   satisfies the whole graph.
2. **No Firebase project is wired up yet.** `Firebase.initializeApp()` in
   `lib/bootstrap.dart` is wrapped in a try/catch so the app still boots
   without it, but `firebase_options.dart` doesn't exist. Run
   `flutterfire configure` (requires a Firebase account/login, which this
   environment doesn't have) before any feature that touches Firestore/Auth/
   Storage/Messaging is implemented.
3. **Kinyarwanda and French strings in `lib/l10n/app_rw.arb` /
   `app_fr.arb` are foundation-stage placeholders**, not reviewed by a
   native speaker or a clinical-terminology reviewer. Fine for scaffolding;
   get a native-speaker/clinical review before these strings reach real
   users, especially once medical terminology enters the ARB files.

No Clean Architecture violations were found: nothing under `features/*/presentation`
imports from a `data/` folder (verified by grep — no feature has any code yet
beyond its README), and nothing under `core/` or `shared/` imports from
`features/`. `analysis_options.yaml` now excludes generated code
(`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `lib/l10n/generated/**`) from
lint/analysis scope, matching the convention noted in §12.
