# prescriptions

The doctor-writes / patient-views prescription lifecycle, plus the "Find Medicine" capability that hands off to the location feature for a nearby-pharmacy search — this app does not manage pharmacies as a first-class entity.

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

No screens, Blocs, entities, or repository implementations exist yet —
this is foundation-stage scaffolding only.
