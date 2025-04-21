import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/test_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mylawyer.db'),
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

  Future<int> insertTest(TestModel test) async {
    final db = await database;
    return await db.insert('tests', test.toMap());
  }

  Future<List<TestModel>> getAllTests() async {
    final db = await database;
    final maps = await db.query('tests');
    return maps.map((map) => TestModel.fromMap(map)).toList();
  }
}
