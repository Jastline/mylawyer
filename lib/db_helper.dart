import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'test_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'mylawyer.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question TEXT,
            options TEXT,
            correctIndex INTEGER,
            lawReference TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTest(TestModel test) async {
    final db = await database;
    await db.insert('tests', test.toMap());
  }

  Future<List<TestModel>> getTests() async {
    final db = await database;
    final result = await db.query('tests');
    return result.map((e) => TestModel.fromMap(e)).toList();
  }
}
