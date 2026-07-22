# Ubuzima Connect

Enterprise, offline-first healthcare platform for Rwanda connecting
Community Health Workers, Doctors, and Patients.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full architecture
explanation, folder-by-folder rationale, and known scalability trade-offs.
This repository is currently at **foundation stage**: Clean Architecture
scaffolding, DI, routing, theming, and localization are wired up — no
application features are implemented yet.

## Stack

Flutter · BLoC · Firebase (Auth, Firestore, Storage, Messaging) · SQLite
(sqflite) · GetIt + Injectable · GoRouter · Freezed · json_serializable ·
Google Maps · Geolocator

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

`build_runner` generates `lib/core/di/injection.config.dart` (DI wiring) and
will generate feature Freezed/JSON models once features land.
`lib/l10n/generated/` (English, Kinyarwanda, French) is generated
automatically by `flutter pub get` via `l10n.yaml`.

### Firebase

No Firebase project is configured yet. Before implementing any feature that
touches Auth/Firestore/Storage/Messaging, run:

```bash
flutterfire configure
```

`lib/bootstrap.dart` currently wraps `Firebase.initializeApp()` in a
try/catch so the app boots without it in the meantime.

## Architecture

Strict Clean Architecture, feature-modularized:

```
lib/
├── core/       # Cross-cutting infrastructure (DI, routing, theme, network, errors, ...)
├── shared/     # Reusable presentation widgets
└── features/   # 14 bounded contexts (authentication, patients, prescriptions, ...)
```

Full rationale, per-folder explanations, and scalability notes:
[`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).
