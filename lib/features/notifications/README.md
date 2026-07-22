# notifications

In-app and push notification presentation/business rules — what a notification means and how it's routed/displayed. Wraps core/services/FirebaseMessagingService rather than talking to the Firebase Messaging SDK directly.

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
