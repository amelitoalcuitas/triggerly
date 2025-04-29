import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _version = 5; // Increment version number

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _version,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create health profile table
    await db.execute('''
      CREATE TABLE health_profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        age INTEGER NOT NULL,
        height REAL NOT NULL,
        weight REAL NOT NULL,
        blood_type TEXT NOT NULL,
        medical_conditions TEXT NOT NULL,
        allergies TEXT NOT NULL,
        medications TEXT NOT NULL
      )
    ''');

    // Create meal history table
    await db.execute('''
      CREATE TABLE meal_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_name TEXT,
        ingredients TEXT,
        reflux_triggers TEXT,
        calories TEXT,
        nutrition_facts TEXT,
        allergens TEXT,
        message TEXT,
        is_error INTEGER,
        image_path TEXT,
        user_triggered INTEGER,
        created_at TEXT NOT NULL
      )
    ''');

    // Add other core tables here as needed
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create meal history table for users upgrading from version 1
      await db.execute('''
        CREATE TABLE meal_history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          meal_name TEXT,
          ingredients TEXT,
          reflux_triggers TEXT,
          calories TEXT,
          nutrition_facts TEXT,
          allergens TEXT,
          message TEXT,
          is_error INTEGER,
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add image_path column for users upgrading from version 2
      await db.execute('ALTER TABLE meal_history ADD COLUMN image_path TEXT');
    }
    if (oldVersion < 4) {
      // Add user_triggered column for users upgrading from version 3
      await db.execute(
        'ALTER TABLE meal_history ADD COLUMN user_triggered INTEGER',
      );
    }
    if (oldVersion < 5) {
      // Ensure user_triggered column exists
      try {
        await db.execute(
          'ALTER TABLE meal_history ADD COLUMN user_triggered INTEGER',
        );
      } catch (e) {
        // Column might already exist, ignore error
      }
    }
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    // Handle database downgrade if needed
    await db.close();
    await deleteDatabase(join(await getDatabasesPath(), 'health_app.db'));
    _database = null;
    await database;
  }
}
