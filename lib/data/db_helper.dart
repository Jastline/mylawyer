import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/test_model.dart';
import '../models/law_article.dart'; // 👈 Добавь это

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
      version: 3, // Увеличена версия для корректного обновления
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

        await db.execute('''
          CREATE TABLE laws (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT,
            chapter TEXT,
            articleNumber TEXT,
            title TEXT,
            content TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE laws (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              content TEXT,
              chapter TEXT
            )
          ''');
        }
        if (oldVersion < 3) {
          // Создаем временную таблицу с новой структурой
          await db.execute('''
            CREATE TABLE laws_new (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              code TEXT,
              chapter TEXT,
              articleNumber TEXT,
              title TEXT,
              content TEXT
            )
          ''');
          // Переносим данные из старой таблицы
          final oldLaws = await db.query('laws');
          for (var law in oldLaws) {
            await db.insert('laws_new', {
              'code': '', // значение по умолчанию
              'articleNumber': '', // значение по умолчанию
              'title': law['title'],
              'content': law['content'],
              'chapter': law['chapter'],
            });
          }

          // Удаляем старую таблицу
          await db.execute('DROP TABLE laws');

          // Переименовываем новую таблицу
          await db.execute('ALTER TABLE laws_new RENAME TO laws');
        }
      },
    );
  }

  // ------- TESTS -------
  Future<int> insertTest(TestModel test) async {
    final db = await database;
    return await db.insert('tests', test.toMap());
  }

  Future<List<TestModel>> getAllTests() async {
    final db = await database;
    final maps = await db.query('tests');
    return maps.map((map) => TestModel.fromMap(map)).toList();
  }

  // ------- LAWS -------
  Future<int> insertLaw(LawArticle law) async {
    final db = await database;
    return await db.insert('laws', law.toMap());
  }

  Future<List<LawArticle>> getAllLaws() async {
    final db = await database;
    final maps = await db.query('laws');
    return maps.map((map) => LawArticle.fromMap(map)).toList();
  }

  Future<List<LawArticle>> searchLaws(String query) async {
    final db = await database;
    final maps = await db.query(
      'laws',
      where: 'title LIKE ? OR content LIKE ? OR code LIKE ? OR articleNumber LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => LawArticle.fromMap(map)).toList();
  }

  Future<LawArticle?> getLawByTitle(String title) async {
    final db = await database;
    final maps = await db.query(
      'laws',
      where: 'title = ?',
      whereArgs: [title],
    );
    if (maps.isNotEmpty) {
      return LawArticle.fromMap(maps.first);
    }
    return null;
  }
}
