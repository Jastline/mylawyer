import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models.dart';

class DatabaseHelper {
  static const _mainDbName = 'main_law_db.db';
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _mainDbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Сначала создаем справочные таблицы
    await db.execute('''
      CREATE TABLE status (
        ID INTEGER PRIMARY KEY,
        status TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    await db.execute('''
      CREATE TABLE author (
        ID INTEGER PRIMARY KEY,
        author TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    await db.execute('''
      CREATE TABLE issued_by (
        ID INTEGER PRIMARY KEY,
        issuedBy TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    await db.execute('''
      CREATE TABLE signed_by (
        ID INTEGER PRIMARY KEY,
        signedBy TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    await db.execute('''
      CREATE TABLE keyword (
        ID INTEGER PRIMARY KEY,
        keyword TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE classifier (
        ID INTEGER PRIMARY KEY,
        classifier TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    await db.execute('''
      CREATE TABLE reference_type (
        ID INTEGER PRIMARY KEY,
        referenceType TEXT NOT NULL DEFAULT 'Неизвестно'
      )
    ''');

    // Затем основную таблицу документов
    await db.execute('''
      CREATE TABLE document (
        ID INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        docDate TEXT NOT NULL,
        docNumber TEXT,
        internalNumber INTEGER,
        statusID INTEGER DEFAULT -1,
        authorID INTEGER DEFAULT -1,
        issuedByID INTEGER DEFAULT -1,
        signedByID INTEGER DEFAULT -1,
        FOREIGN KEY (statusID) REFERENCES status (ID),
        FOREIGN KEY (authorID) REFERENCES author (ID),
        FOREIGN KEY (issuedByID) REFERENCES issued_by (ID),
        FOREIGN KEY (signedByID) REFERENCES signed_by (ID)
      )
    ''');

    // Затем таблицы, зависящие от document
    await db.execute('''
      CREATE TABLE document_text (
        ID INTEGER PRIMARY KEY,
        documentID INTEGER NOT NULL,
        text TEXT NOT NULL,
        FOREIGN KEY (documentID) REFERENCES document (ID)
      )
    ''');

    await db.execute('''
      CREATE TABLE document_keyword (
        ID INTEGER PRIMARY KEY,
        documentID INTEGER NOT NULL,
        keywordID INTEGER NOT NULL,
        FOREIGN KEY (documentID) REFERENCES document (ID),
        FOREIGN KEY (keywordID) REFERENCES keyword (ID)
      )
    ''');

    await db.execute('''
      CREATE TABLE document_classifier (
        ID INTEGER PRIMARY KEY,
        documentID INTEGER NOT NULL,
        classifierID INTEGER NOT NULL,
        FOREIGN KEY (documentID) REFERENCES document (ID),
        FOREIGN KEY (classifierID) REFERENCES classifier (ID)
      )
    ''');

    await db.execute('''
      CREATE TABLE document_link (
        ID INTEGER PRIMARY KEY,
        sourceDocumentID INTEGER NOT NULL,
        targetDocumentID INTEGER NOT NULL,
        referenceTypeID INTEGER NOT NULL,
        FOREIGN KEY (sourceDocumentID) REFERENCES document (ID),
        FOREIGN KEY (targetDocumentID) REFERENCES document (ID),
        FOREIGN KEY (referenceTypeID) REFERENCES reference_type (ID)
      )
    ''');

    // Пользовательские таблицы
    await db.execute('''
      CREATE TABLE user_profile (
        ID INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        totalLawsRead INTEGER DEFAULT 0,
        lawsByCategory TEXT,
        timeSpent TEXT,
        lightTheme BOOLEAN DEFAULT TRUE
      )
    ''');

    await db.execute('''
      CREATE TABLE document_user (
        ID INTEGER PRIMARY KEY,
        documentID INTEGER NOT NULL,
        userID INTEGER NOT NULL,
        pinned BOOLEAN DEFAULT FALSE,
        readAt TEXT,
        pathReadDB TEXT,
        FOREIGN KEY (documentID) REFERENCES document (ID),
        FOREIGN KEY (userID) REFERENCES user_profile (ID)
      )
    ''');

    // Заполняем справочники
    await Status.seed(db);
    await Classifier.seed(db);
    await ReferenceType.seed(db);
  }

  Future<String> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final tempPath = join(tempDir.path, 'temp_law_${DateTime.now().millisecondsSinceEpoch}.db');
      final file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);
      return tempPath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  Future<void> downloadAndMergeDb({
    required bool isMain,
    required String docType,
    required int year,
  }) async {
    final db = await database;
    final url = _buildDownloadUrl(isMain, docType, year);
    final tempPath = await _downloadFile(url);
    final downloadedDb = await openDatabase(tempPath);

    try {
      await db.transaction((txn) async {
        // Импорт данных из всех таблиц
        await _importTable(db, downloadedDb, 'status');
        await _importTable(db, downloadedDb, 'author');
        await _importTable(db, downloadedDb, 'issued_by');
        await _importTable(db, downloadedDb, 'signed_by');
        await _importTable(db, downloadedDb, 'keyword');
        await _importTable(db, downloadedDb, 'classifier');
        await _importTable(db, downloadedDb, 'reference_type');
        await _importTable(db, downloadedDb, 'document');
        await _importTable(db, downloadedDb, 'document_text');
        await _importTable(db, downloadedDb, 'document_keyword');
        await _importTable(db, downloadedDb, 'document_classifier');
        await _importTable(db, downloadedDb, 'document_link');
      });
    } finally {
      await downloadedDb.close();
      await File(tempPath).delete();
    }
  }

  Future<void> _importTable(
      Database db,
      Database sourceDb,
      String tableName,
      ) async {
    try {
      final batch = db.batch();
      final data = await sourceDb.query(tableName);

      for (final row in data) {
        batch.insert(
          tableName,
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      print('Error importing $tableName: $e');
    }
  }

  String _buildDownloadUrl(bool isMain, String docType, int year) {
    final folder = isMain ? 'основные' : 'дополнительные';
    return 'https://disk.yandex.ru/d/p3uxHz8DDCnmkA/$folder/$docType/$year.db';
  }

  Future<void> deleteDocumentsByYearAndType({
    required String docType,
    required int year,
  }) async {
    final db = await database;
    await db.delete(
      'document',
      where: 'docType = ? AND substr(docDate, 1, 4) = ?',
      whereArgs: [docType, year.toString()],
    );
  }
}