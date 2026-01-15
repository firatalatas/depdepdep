import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../models/earthquake_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('earthquakes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Return a dummy DB or handle specifically?
      // Actually throwing or getting here is bad if we try to use it.
      // But openDatabase fails on web.
      throw UnsupportedError('DB not supported on Web');
    }
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE earthquakes (
      id TEXT PRIMARY KEY,
      magnitude REAL,
      depth REAL,
      time TEXT,
      place TEXT,
      lat REAL,
      lon REAL,
      source TEXT,
      created_at INTEGER
    )
    ''');
  }

  Future<void> insertEarthquake(Earthquake earthquake) async {
    if (kIsWeb) return;
    final db = await instance.database;
    await db.insert(
      'earthquakes',
      earthquake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertEarthquakes(List<Earthquake> earthquakes) async {
    if (kIsWeb) return;
    final db = await instance.database;
    final batch = db.batch();
    for (var eq in earthquakes) {
      batch.insert(
        'earthquakes',
        eq.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Earthquake>> getEarthquakes() async {
    if (kIsWeb) return [];
    final db = await instance.database;
    final result = await db.query('earthquakes', orderBy: 'time DESC');
    return result.map((json) => Earthquake.fromMap(json)).toList();
  }

  Future<void> clearEarthquakes() async {
     if (kIsWeb) return;
     final db = await instance.database;
     await db.delete('earthquakes');
  }
}
