/// Table and column name constants, one block per feature, so schema
/// migrations never collide on a literal string typo. Each feature adds its
/// own block here as its local data source lands.
abstract final class DatabaseTables {
  static const String syncQueue = 'sync_queue';
  static const String syncQueueColId = 'id';
  static const String syncQueueColEntityType = 'entity_type';
  static const String syncQueueColEntityId = 'entity_id';
  static const String syncQueueColOperation = 'operation';
  static const String syncQueueColPayload = 'payload';
  static const String syncQueueColStatus = 'status';
  static const String syncQueueColRetryCount = 'retry_count';
  static const String syncQueueColCreatedAt = 'created_at';
}
