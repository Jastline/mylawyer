import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models.dart';

class DatabaseHelper {
  static const _databaseName = 'main_law_db.db';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    // Создаем таблицу типов документов
    await database.execute('''
      CREATE TABLE document_type (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        docType TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу статусов
    await database.execute('''
      CREATE TABLE status (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        status TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу авторов
    await database.execute('''
      CREATE TABLE author (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        author TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу издателей
    await database.execute('''
      CREATE TABLE issued_by (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        issuedBy TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу подписавших
    await database.execute('''
      CREATE TABLE signed_by (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        signedBy TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу ключевых слов
    await database.execute('''
      CREATE TABLE keyword (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу классификаторов
    await database.execute('''
      CREATE TABLE classifier (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        classifier TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу типов ссылок
    await database.execute('''
      CREATE TABLE link_type (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        typeLink TEXT NOT NULL UNIQUE
      )
    ''');

    // Создаем таблицу пользователей
    await database.execute('''
      CREATE TABLE user_profile (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        totalLawsRead INTEGER DEFAULT 0,
        lawsByCategory TEXT,
        timeSpent TEXT,
        lightTheme BOOLEAN DEFAULT TRUE
      )
    ''');

    // Создаем основную таблицу документов
    await database.execute('''
      CREATE TABLE rus_law_document (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        docDate TEXT NOT NULL,
        docNumber TEXT,
        internalNumber INTEGER,
        isWidelyUsed BOOLEAN NOT NULL DEFAULT FALSE,
        docTypeID INTEGER NOT NULL,
        statusID INTEGER NOT NULL,
        authorID INTEGER NOT NULL,
        issuedByID INTEGER NOT NULL,
        signedByID INTEGER NOT NULL,
        FOREIGN KEY (docTypeID) REFERENCES document_type (ID),
        FOREIGN KEY (statusID) REFERENCES status (ID),
        FOREIGN KEY (authorID) REFERENCES author (ID),
        FOREIGN KEY (issuedByID) REFERENCES issued_by (ID),
        FOREIGN KEY (signedByID) REFERENCES signed_by (ID)
      )
    ''');

    // Создаем таблицу текстов документов
    await database.execute('''
      CREATE TABLE rus_law_text (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        documentID INTEGER NOT NULL,
        text TEXT NOT NULL,
        FOREIGN KEY (documentID) REFERENCES rus_law_document (ID)
      )
    ''');

    // Создаем таблицу ключевых слов документов
    await database.execute('''
      CREATE TABLE rus_law_keyword (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        documentID INTEGER NOT NULL,
        keywordID INTEGER NOT NULL,
        FOREIGN KEY (documentID) REFERENCES rus_law_document (ID),
        FOREIGN KEY (keywordID) REFERENCES keyword (ID)
      )
    ''');

    // Создаем таблицу ссылок документов
    await database.execute('''
      CREATE TABLE document_link (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        sourceDocumentID INTEGER NOT NULL,
        targetDocumentID INTEGER NOT NULL,
        typeLinkID INTEGER NOT NULL,
        FOREIGN KEY (sourceDocumentID) REFERENCES rus_law_document (ID),
        FOREIGN KEY (targetDocumentID) REFERENCES rus_law_document (ID),
        FOREIGN KEY (typeLinkID) REFERENCES link_type (ID)
      )
    ''');

    // Создаем таблицу связей документов с пользователями
    await database.execute('''
      CREATE TABLE document_user (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        documentID INTEGER NOT NULL,
        userID INTEGER NOT NULL,
        pinned BOOLEAN DEFAULT FALSE,
        readAt TEXT,
        pathReadDB TEXT,
        FOREIGN KEY (documentID) REFERENCES rus_law_document (ID),
        FOREIGN KEY (userID) REFERENCES user_profile (ID)
      )
    ''');

    // Создаем таблицу ссылок на классификаторы
    await database.execute('''
      CREATE TABLE rus_law_reference (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        documentID INTEGER NOT NULL,
        classifierID INTEGER NOT NULL,
        FOREIGN KEY (documentID) REFERENCES rus_law_document (ID),
        FOREIGN KEY (classifierID) REFERENCES classifier (ID)
      )
    ''');

    // Заполняем начальные данные
    await _seedInitialData(database);
  }

  Future<void> _seedInitialData(Database db) async {
    // Заполняем типы документов
    await _insertDocumentType(db, 'Закон');
    await _insertDocumentType(db, 'Закон Российской Федерации о поправке к Конституции');
    await _insertDocumentType(db, 'Заявление');
    await _insertDocumentType(db, 'Изменения');
    await _insertDocumentType(db, 'Кодекс');
    await _insertDocumentType(db, 'Конституция');
    await _insertDocumentType(db, 'Обращение');
    await _insertDocumentType(db, 'Определение');
    await _insertDocumentType(db, 'Основы законодательства');
    await _insertDocumentType(db, 'Официальное разъяснение');
    await _insertDocumentType(db, 'Письмо');
    await _insertDocumentType(db, 'Положение');
    await _insertDocumentType(db, 'Послание');
    await _insertDocumentType(db, 'Постановление');
    await _insertDocumentType(db, 'Постановление Правления');
    await _insertDocumentType(db, 'Пресс-релиз');
    await _insertDocumentType(db, 'Приказ');
    await _insertDocumentType(db, 'Распоряжение');
    await _insertDocumentType(db, 'Регламент');
    await _insertDocumentType(db, 'Реестр');
    await _insertDocumentType(db, 'Решение');
    await _insertDocumentType(db, 'Указ');
    await _insertDocumentType(db, 'Указание');
    await _insertDocumentType(db, 'Федеральный закон');
    await _insertDocumentType(db, 'Федеральный конституционный закон');
    await _insertDocumentType(db, 'Временная инструкция');
    await _insertDocumentType(db, 'Временный порядок');
    await _insertDocumentType(db, 'Выписка');
    await _insertDocumentType(db, 'Выписка из приказа');
    await _insertDocumentType(db, 'Декларация');
    await _insertDocumentType(db, 'Договор');
    await _insertDocumentType(db, 'Доктрина');
    await _insertDocumentType(db, 'Дополнение');
    await _insertDocumentType(db, 'Дополнения');
    await _insertDocumentType(db, 'Заключение');
    await _insertDocumentType(db, 'Изменение');
    await _insertDocumentType(db, 'Изменения и дополнения');
    await _insertDocumentType(db, 'Инструкция');
    await _insertDocumentType(db, 'Информационное письмо');
    await _insertDocumentType(db, 'Конвенция');
    await _insertDocumentType(db, 'Официальное сообщение');
    await _insertDocumentType(db, 'Порядок');
    await _insertDocumentType(db, 'Правила');
    await _insertDocumentType(db, 'Протокол');
    await _insertDocumentType(db, 'Разъяснение');
    await _insertDocumentType(db, 'Разъяснения');
    await _insertDocumentType(db, 'Рамочное соглашение');
    await _insertDocumentType(db, 'Рекомендации');
    await _insertDocumentType(db, 'Руководство');
    await _insertDocumentType(db, 'Соглашение');
    await _insertDocumentType(db, 'Сообщение');
    await _insertDocumentType(db, 'Справка');
    await _insertDocumentType(db, 'Ставки');
    await _insertDocumentType(db, 'Тарифное соглашение');
    await _insertDocumentType(db, 'Телеграмма');
    await _insertDocumentType(db, 'Типовое положение');
    await _insertDocumentType(db, 'Условия');
    await _insertDocumentType(db, 'Устав');
    await _insertDocumentType(db, 'Циркулярное письмо');

    // Заполняем статусы
    await _insertStatus(db, 'Действует с изменениями');
    await _insertStatus(db, 'Действует без изменений');
    await _insertStatus(db, 'Утратил силу');
    await _insertStatus(db, 'Не вступил в силу');

    // Заполняем типы ссылок
    await _insertLinkType(db, 'Ссылается на');
    await _insertLinkType(db, 'Изменяет');
    await _insertLinkType(db, 'Отменяет');
  }

  Future<void> _insertDocumentType(Database db, String docType) async {
    await db.insert(
      'document_type',
      {'docType': docType},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> _insertStatus(Database db, String status) async {
    await db.insert(
      'status',
      {'status': status},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> _insertLinkType(Database db, String typeLink) async {
    await db.insert(
      'link_type',
      {'typeLink': typeLink},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> downloadAndMergeDatabase({
    required bool isMainCategory,
    required String documentType,
    required int year,
  }) async {
    final db = await this.database;
    final url = _buildDownloadUrl(
      isMainCategory: isMainCategory,
      documentType: documentType,
      year: year,
    );
    final tempPath = await _downloadDatabaseFile(url);
    final downloadedDb = await openDatabase(tempPath);

    try {
      await db.transaction((txn) async {
        // 1. Получаем ID типа документа
        final docTypeId = await _getOrCreateDocumentType(txn, documentType);

        // 2. Импортируем справочные таблицы
        await _importReferenceTables(txn, downloadedDb);

        // 3. Импортируем документы с метаданными
        await _importDocuments(txn, downloadedDb, docTypeId, isMainCategory);

        // 4. Импортируем связанные данные
        await _importRelatedData(txn, downloadedDb);
      });
    } finally {
      await downloadedDb.close();
      await File(tempPath).delete();
    }
  }

  Future<int> _getOrCreateDocumentType(Transaction txn, String docType) async {
    try {
      return await txn.insert(
        'document_type',
        {'docType': docType},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      final existing = await txn.query(
        'document_type',
        where: 'docType = ?',
        whereArgs: [docType],
        limit: 1,
      );
      return existing.first['ID'] as int;
    }
  }

  Future<void> _importReferenceTables(Transaction txn, Database sourceDb) async {
    const tables = [
      'status',
      'author',
      'issued_by',
      'signed_by',
      'keyword',
      'classifier',
      'link_type'
    ];

    for (final table in tables) {
      await _importTable(txn, sourceDb, table);
    }
  }

  Future<void> _importDocuments(
      Transaction txn,
      Database sourceDb,
      int docTypeId,
      bool isWidelyUsed,
      ) async {
    final batch = txn.batch();
    final documents = await sourceDb.query('rus_law_document');

    for (final doc in documents) {
      final newDoc = Map<String, dynamic>.from(doc);
      newDoc['docTypeID'] = docTypeId;
      newDoc['isWidelyUsed'] = isWidelyUsed ? 1 : 0;

      batch.insert(
        'rus_law_document',
        newDoc,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> _importRelatedData(Transaction txn, Database sourceDb) async {
    const tables = [
      'rus_law_text',
      'rus_law_keyword',
      'rus_law_reference',
      'document_link'
    ];

    for (final table in tables) {
      await _importTable(txn, sourceDb, table);
    }
  }

  Future<void> _importTable(
      Transaction txn,
      Database sourceDb,
      String tableName,
      ) async {
    try {
      final batch = txn.batch();
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
      rethrow;
    }
  }

  Future<String> _downloadDatabaseFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.statusCode}');
      }

      final tempDir = await getTemporaryDirectory();
      final path = join(tempDir.path, 'temp_db_${DateTime.now().millisecondsSinceEpoch}.db');
      await File(path).writeAsBytes(response.bodyBytes);
      return path;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  String _buildDownloadUrl({
    required bool isMainCategory,
    required String documentType,
    required int year,
  }) {
    final category = isMainCategory ? 'основные' : 'дополнительные';
    return 'https://disk.yandex.ru/d/p3uxHz8DDCnmkA/$category/$documentType/$year.db';
  }

  Future<List<RusLawDocument>> getDocuments({
    int? docTypeId,
    bool? isWidelyUsed,
    int? year,
    int? statusId,
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await database;
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (docTypeId != null) {
      where.add('docTypeID = ?');
      whereArgs.add(docTypeId);
    }

    if (isWidelyUsed != null) {
      where.add('isWidelyUsed = ?');
      whereArgs.add(isWidelyUsed ? 1 : 0);
    }

    if (year != null) {
      where.add('strftime("%Y", docDate) = ?');
      whereArgs.add(year.toString());
    }

    if (statusId != null) {
      where.add('statusID = ?');
      whereArgs.add(statusId);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';
    final query = '''
      SELECT d.*, dt.docType as docTypeName
      FROM rus_law_document d
      JOIN document_type dt ON d.docTypeID = dt.ID
      $whereClause
      ORDER BY d.docDate DESC
      LIMIT ? OFFSET ?
    ''';

    final result = await db.rawQuery(query, [...whereArgs, limit, offset]);
    return result.map(RusLawDocument.fromMap).toList();
  }

  Future<List<DocumentType>> getAllDocumentTypes() async {
    final db = await database;
    final result = await db.query('document_type', orderBy: 'docType');
    return result.map(DocumentType.fromMap).toList();
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}