import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const int _version =
      6; // Increment version number for is_not_food column

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDB('health_app.db');
      return _database!;
    } catch (e) {
      developer.log(
        'Database initialization error: $e',
        name: 'DatabaseHelper',
      );
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      developer.log('Database path: $path', name: 'DatabaseHelper');

      return await openDatabase(
        path,
        version: _version,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
        onOpen: (db) {
          developer.log('Database opened successfully', name: 'DatabaseHelper');
        },
      );
    } catch (e) {
      developer.log('Error initializing database: $e', name: 'DatabaseHelper');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
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
          is_not_food INTEGER,
          created_at TEXT NOT NULL
        )
      ''');
      developer.log(
        'Database tables created successfully',
        name: 'DatabaseHelper',
      );
    } catch (e) {
      developer.log(
        'Error creating database tables: $e',
        name: 'DatabaseHelper',
      );
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      developer.log(
        'Upgrading database from version $oldVersion to $newVersion',
        name: 'DatabaseHelper',
      );

      if (oldVersion < 2) {
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
        await db.execute('ALTER TABLE meal_history ADD COLUMN image_path TEXT');
      }
      if (oldVersion < 4) {
        await db.execute(
          'ALTER TABLE meal_history ADD COLUMN user_triggered INTEGER',
        );
      }
      if (oldVersion < 5) {
        try {
          await db.execute(
            'ALTER TABLE meal_history ADD COLUMN user_triggered INTEGER',
          );
        } catch (e) {
          developer.log(
            'Column user_triggered might already exist',
            name: 'DatabaseHelper',
          );
        }
      }
      if (oldVersion < 6) {
        try {
          await db.execute(
            'ALTER TABLE meal_history ADD COLUMN is_not_food INTEGER',
          );
        } catch (e) {
          developer.log(
            'Column is_not_food might already exist',
            name: 'DatabaseHelper',
          );
        }
      }
      developer.log(
        'Database upgrade completed successfully',
        name: 'DatabaseHelper',
      );
    } catch (e) {
      developer.log(
        'Error during database upgrade: $e',
        name: 'DatabaseHelper',
      );
      rethrow;
    }
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    try {
      developer.log(
        'Downgrading database from version $oldVersion to $newVersion',
        name: 'DatabaseHelper',
      );
      await db.close();
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'health_app.db');
      await deleteDatabase(path);
      _database = null;
      await database;
      developer.log(
        'Database downgrade completed successfully',
        name: 'DatabaseHelper',
      );
    } catch (e) {
      developer.log(
        'Error during database downgrade: $e',
        name: 'DatabaseHelper',
      );
      rethrow;
    }
  }
}
