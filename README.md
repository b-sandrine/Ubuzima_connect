# Ubuzima Connect

Offline-first healthcare platform for Rwanda connecting Community Health
Workers, Doctors, and Patients. Built with Flutter, BLoC, and a Firebase
(Firestore) backend, following a strict Clean Architecture.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full architecture
explanation and [`docs/firestore-data-model.md`](docs/firestore-data-model.md)
for the Firestore data model, ERD, and security rules.

## Stack

Flutter · BLoC · Firebase (Auth, Firestore, Storage, Messaging) · SQLite
(sqflite) · GetIt + Injectable · GoRouter · Freezed · json_serializable

## Prerequisites

- Flutter 3.44+ / Dart 3.12+ (`flutter --version`)
- An Android emulator or a physical device. **Run on a device/emulator — not
  web or desktop.**

## Getting started

```bash
git clone <repo-url>
cd Ubuzima_connect

flutter pub get                                    # also generates l10n
dart run build_runner build --delete-conflicting-outputs   # DI + Freezed
flutter run                                        # pick an Android device
```

`build_runner` generates `lib/core/di/injection.config.dart` (DI wiring) and
the Freezed/JSON files. Localizations (English, Kinyarwanda, French) are
generated into `lib/l10n/generated/` by `flutter pub get` via `l10n.yaml`.

## Firebase

The app is already configured for the Firebase project **`ubuzima-connect-alu`**
(`lib/firebase_options.dart`, `android/app/google-services.json`). To stand the
backend up on a fresh clone:

```bash
# 1. Create the Firestore database once (region is permanent):
firebase firestore:databases:create "(default)" --location eur3 \
  --project ubuzima-connect-alu

# 2. Deploy the security rules:
firebase deploy --only firestore:rules --project ubuzima-connect-alu
```

The screens seed their demo patient into Firestore on first read, so the app
has live data to read and write immediately. The security rules
(`firestore.rules`) require an authenticated user; while developing screens
that are not yet behind login, deploy open test rules or use the console's
"test mode".

## Testing

```bash
flutter analyze          # static analysis — expects zero issues
flutter test             # unit + widget tests
flutter test --coverage  # writes coverage/lcov.info
```

The data layer is tested against an in-memory Firestore
(`fake_cloud_firestore`), so CRUD logic is verified without a live project.

## Architecture

Strict Clean Architecture, feature-modularized:

```
lib/
├── core/       # Cross-cutting infrastructure (DI, routing, theme, errors, ...)
├── shared/     # Reusable presentation widgets
└── features/   # Bounded contexts (authentication, prescriptions, referrals,
                #   medical_records, community_health_workers, ...)
```

Each feature is split into `data/` (Firestore + local sources, repositories),
`domain/` (entities, repository contracts, use cases), and `presentation/`
(BLoC, pages, widgets). Full rationale in
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Screenshots

_Add screenshots of the running app here for the report._
