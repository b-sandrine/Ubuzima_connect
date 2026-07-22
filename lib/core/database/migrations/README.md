# Migrations

Each schema change gets its own numbered file: `0001_create_sync_queue.dart`,
`0002_add_patients_table.dart`, etc. Never edit a migration once it has
shipped — add a new one instead. `AppDatabase._onUpgrade` applies them in
order, guarded by `if (oldVersion < N)`.

No migrations exist yet at foundation stage — the first one lands with the
first feature that needs local persistence.
