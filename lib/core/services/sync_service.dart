import 'package:injectable/injectable.dart';

/// Cross-feature entry point for triggering/observing background sync.
/// The real engine — queueing policy, retry backoff, conflict resolution —
/// belongs to `features/offline_sync`'s domain layer; `core` only defines
/// the contract other features are allowed to depend on, so nothing outside
/// `offline_sync` needs to know how sync actually works.
abstract interface class SyncService {
  Future<void> syncNow();

  Stream<int> get pendingItemCountStream;

  bool get isSyncing;
}

/// Foundation-stage placeholder. Remove the `@LazySingleton` annotation
/// here once `features/offline_sync` registers its real implementation —
/// GetIt only allows one binding per interface.
@LazySingleton(as: SyncService)
class NoOpSyncService implements SyncService {
  @override
  Future<void> syncNow() async {}

  @override
  Stream<int> get pendingItemCountStream => Stream.value(0);

  @override
  bool get isSyncing => false;
}
