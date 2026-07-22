import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Single sqflite handle shared by every feature's local data source.
///
/// Schema changes are added as a new numbered file under
/// `core/database/migrations/` and applied in [_onUpgrade] in order — an
/// already-shipped migration is never edited after release.
@lazySingleton
class AppDatabase {
  static const int _databaseVersion = 1;
  static const String _databaseName = 'ubuzima_connect.db';

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Each feature's local data source contributes its own CREATE TABLE
    // statement here as it lands. Kept empty at foundation stage.
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Numbered migrations from migrations/ are applied here, in order,
    // guarded by `if (oldVersion < N)`.
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
