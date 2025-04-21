import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/test_model.dart';
import '../models/law_article.dart';
import '../models/user_profile.dart';

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
      version: 4, // Увеличена версия для добавления профиля
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

        await db.execute('''
          CREATE TABLE profiles (
            id TEXT PRIMARY KEY,
            name TEXT,
            avatarPath TEXT,
            totalLawsRead INTEGER,
            testsCompleted INTEGER,
            lawsByCategory TEXT,
            timeSpent TEXT,
            achievements TEXT
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

          final oldLaws = await db.query('laws');
          for (var law in oldLaws) {
            await db.insert('laws_new', {
              'code': '',
              'articleNumber': '',
              'title': law['title'],
              'content': law['content'],
              'chapter': law['chapter'],
            });
          }

          await db.execute('DROP TABLE laws');
          await db.execute('ALTER TABLE laws_new RENAME TO laws');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE profiles (
              id TEXT PRIMARY KEY,
              name TEXT,
              avatarPath TEXT,
              totalLawsRead INTEGER,
              testsCompleted INTEGER,
              lawsByCategory TEXT,
              timeSpent TEXT,
              achievements TEXT
            )
          ''');
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

  // ------- PROFILE -------
  Future<int> saveProfile(UserProfile profile) async {
    final db = await database;
    return db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getProfile() async {
    final db = await database;
    final maps = await db.query('profiles', limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }
}