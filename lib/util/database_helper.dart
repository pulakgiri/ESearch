import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/saved_job.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'esearch.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // add category column in version 2
          await db.execute('ALTER TABLE saved_jobs ADD COLUMN category TEXT');
        }
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_jobs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        company TEXT,
        salary TEXT,
        location TEXT,
        type TEXT,
        vacancy TEXT,
        category TEXT
      )
    ''');
  }

  Future<int> insertJob(SavedJob job) async {
    final db = await database;
    return await db.insert('saved_jobs', job.toMap());
  }

  Future<List<SavedJob>> getSavedJobs() async {
    final db = await database;
    final maps = await db.query('saved_jobs', orderBy: 'id DESC');
    return maps.map((m) => SavedJob.fromMap(m)).toList();
  }

  Future<int> deleteJob(int id) async {
    final db = await database;
    return await db.delete('saved_jobs', where: 'id = ?', whereArgs: [id]);
  }

  /// check uniqueness by title+company+optional category
  Future<bool> isJobSaved(
    String title,
    String company, {
    String? category,
  }) async {
    final db = await database;
    String whereClause = 'title = ? AND company = ?';
    final args = [title, company];
    if (category != null) {
      whereClause += ' AND category = ?';
      args.add(category);
    }
    final maps = await db.query(
      'saved_jobs',
      where: whereClause,
      whereArgs: args,
      limit: 1,
    );
    return maps.isNotEmpty;
  }
}
