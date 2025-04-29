import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'database_initializer.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  final DatabaseInitializer _initializer = DatabaseInitializer();
  bool _isInitializing = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_isInitializing) {
      // Ожидаем завершения инициализации, если она уже идет
      while (_database == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _database!;
    }

    _isInitializing = true;
    try {
      _database = await _initializer.initialize();
      return _database!;
    } finally {
      _isInitializing = false;
    }
  }

  // ======================== Основные CRUD операции ========================

  // Author
  Future<int> insertAuthor(Author author) async {
    final db = await database;
    return await db.insert('author', author.toMap());
  }

  Future<List<Author>> getAuthors() async {
    final db = await database;
    final maps = await db.query('author');
    return maps.map((map) => Author.fromMap(map)).toList();
  }

  Future<Author?> getAuthorById(int id) async {
    final db = await database;
    final maps = await db.query('author', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Author.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateAuthor(Author author) async {
    final db = await database;
    return await db.update('author', author.toMap(), where: 'ID = ?', whereArgs: [author.id]);
  }

  Future<int> deleteAuthor(int id) async {
    final db = await database;
    return await db.delete('author', where: 'ID = ?', whereArgs: [id]);
  }

  // Classifier
  Future<int> insertClassifier(Classifier classifier) async {
    final db = await database;
    return await db.insert('classifier', classifier.toMap());
  }

  Future<List<Classifier>> getClassifiers() async {
    final db = await database;
    final maps = await db.query('classifier');
    return maps.map((map) => Classifier.fromMap(map)).toList();
  }

  Future<Classifier?> getClassifierById(int id) async {
    final db = await database;
    final maps = await db.query('classifier', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Classifier.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateClassifier(Classifier classifier) async {
    final db = await database;
    return await db.update('classifier', classifier.toMap(), where: 'ID = ?', whereArgs: [classifier.id]);
  }

  Future<int> deleteClassifier(int id) async {
    final db = await database;
    return await db.delete('classifier', where: 'ID = ?', whereArgs: [id]);
  }

  // DocumentType
  Future<int> insertDocumentType(DocumentType docType) async {
    final db = await database;
    return await db.insert('document_type', docType.toMap());
  }

  Future<List<DocumentType>> getDocumentTypes() async {
    final db = await database;
    final maps = await db.query('document_type');
    return maps.map((map) => DocumentType.fromMap(map)).toList();
  }

  Future<DocumentType?> getDocumentTypeById(int id) async {
    final db = await database;
    final maps = await db.query('document_type', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DocumentType.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateDocumentType(DocumentType docType) async {
    final db = await database;
    return await db.update('document_type', docType.toMap(), where: 'ID = ?', whereArgs: [docType.id]);
  }

  Future<int> deleteDocumentType(int id) async {
    final db = await database;
    return await db.delete('document_type', where: 'ID = ?', whereArgs: [id]);
  }

  // IssuedBy
  Future<int> insertIssuedBy(IssuedBy issuedBy) async {
    final db = await database;
    return await db.insert('issued_by', issuedBy.toMap());
  }

  Future<List<IssuedBy>> getIssuedBys() async {
    final db = await database;
    final maps = await db.query('issued_by');
    return maps.map((map) => IssuedBy.fromMap(map)).toList();
  }

  Future<IssuedBy?> getIssuedByById(int id) async {
    final db = await database;
    final maps = await db.query('issued_by', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return IssuedBy.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateIssuedBy(IssuedBy issuedBy) async {
    final db = await database;
    return await db.update('issued_by', issuedBy.toMap(), where: 'ID = ?', whereArgs: [issuedBy.id]);
  }

  Future<int> deleteIssuedBy(int id) async {
    final db = await database;
    return await db.delete('issued_by', where: 'ID = ?', whereArgs: [id]);
  }

  // Keyword
  Future<int> insertKeyword(Keyword keyword) async {
    final db = await database;
    return await db.insert('keyword', keyword.toMap());
  }

  Future<List<Keyword>> getKeywords() async {
    final db = await database;
    final maps = await db.query('keyword');
    return maps.map((map) => Keyword.fromMap(map)).toList();
  }

  Future<Keyword?> getKeywordById(int id) async {
    final db = await database;
    final maps = await db.query('keyword', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Keyword.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateKeyword(Keyword keyword) async {
    final db = await database;
    return await db.update('keyword', keyword.toMap(), where: 'ID = ?', whereArgs: [keyword.id]);
  }

  Future<int> deleteKeyword(int id) async {
    final db = await database;
    return await db.delete('keyword', where: 'ID = ?', whereArgs: [id]);
  }

  // RusLawDocument
  Future<int> insertRusLawDocument(RusLawDocument document) async {
    final db = await database;
    return await db.insert('rus_law_document', document.toMap());
  }

  Future<List<RusLawDocument>> getRusLawDocuments() async {
    final db = await database;
    final maps = await db.query('rus_law_document');
    return maps.map((map) => RusLawDocument.fromMap(map)).toList();
  }

  Future<RusLawDocument?> getRusLawDocumentById(int id) async {
    final db = await database;
    final maps = await db.query('rus_law_document', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RusLawDocument.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRusLawDocument(RusLawDocument document) async {
    final db = await database;
    return await db.update('rus_law_document', document.toMap(), where: 'ID = ?', whereArgs: [document.id]);
  }

  Future<int> deleteRusLawDocument(int id) async {
    final db = await database;
    return await db.delete('rus_law_document', where: 'ID = ?', whereArgs: [id]);
  }

  // RusLawKeyword
  Future<int> insertRusLawKeyword(RusLawKeyword keyword) async {
    final db = await database;
    return await db.insert('rus_law_keyword', keyword.toMap());
  }

  Future<List<RusLawKeyword>> getRusLawKeywords() async {
    final db = await database;
    final maps = await db.query('rus_law_keyword');
    return maps.map((map) => RusLawKeyword.fromMap(map)).toList();
  }

  Future<RusLawKeyword?> getRusLawKeywordById(int id) async {
    final db = await database;
    final maps = await db.query('rus_law_keyword', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RusLawKeyword.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRusLawKeyword(RusLawKeyword keyword) async {
    final db = await database;
    return await db.update('rus_law_keyword', keyword.toMap(), where: 'ID = ?', whereArgs: [keyword.id]);
  }

  Future<int> deleteRusLawKeyword(int id) async {
    final db = await database;
    return await db.delete('rus_law_keyword', where: 'ID = ?', whereArgs: [id]);
  }

  // RusLawReference
  Future<int> insertRusLawReference(RusLawReference reference) async {
    final db = await database;
    return await db.insert('rus_law_reference', reference.toMap());
  }

  Future<List<RusLawReference>> getRusLawReferences() async {
    final db = await database;
    final maps = await db.query('rus_law_reference');
    return maps.map((map) => RusLawReference.fromMap(map)).toList();
  }

  Future<RusLawReference?> getRusLawReferenceById(int id) async {
    final db = await database;
    final maps = await db.query('rus_law_reference', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RusLawReference.fromMap
        (maps.first);
    }
    return null;
  }

  Future<int> updateRusLawReference(RusLawReference reference) async {
    final db = await database;
    return await db.update('rus_law_reference', reference.toMap(), where: 'ID = ?', whereArgs: [reference.id]);
  }

  Future<int> deleteRusLawReference(int id) async {
    final db = await database;
    return await db.delete('rus_law_reference', where: 'ID = ?', whereArgs: [id]);
  }

  // RusLawText
  Future<int> insertRusLawText(RusLawText text) async {
    final db = await database;
    return await db.insert('rus_law_text', text.toMap());
  }

  Future<List<RusLawText>> getRusLawTexts() async {
    final db = await database;
    final maps = await db.query('rus_law_text');
    return maps.map((map) => RusLawText.fromMap(map)).toList();
  }

  Future<RusLawText?> getRusLawTextById(int id) async {
    final db = await database;
    final maps = await db.query('rus_law_text', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RusLawText.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRusLawText(RusLawText text) async {
    final db = await database;
    return await db.update('rus_law_text', text.toMap(), where: 'ID = ?', whereArgs: [text.id]);
  }

  Future<int> deleteRusLawText(int id) async {
    final db = await database;
    return await db.delete('rus_law_text', where: 'ID = ?', whereArgs: [id]);
  }

  // SignedBy
  Future<int> insertSignedBy(SignedBy signedBy) async {
    final db = await database;
    return await db.insert('signed_by', signedBy.toMap());
  }

  Future<List<SignedBy>> getSignedBys() async {
    final db = await database;
    final maps = await db.query('signed_by');
    return maps.map((map) => SignedBy.fromMap(map)).toList();
  }

  Future<SignedBy?> getSignedByById(int id) async {
    final db = await database;
    final maps = await db.query('signed_by', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SignedBy.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSignedBy(SignedBy signedBy) async {
    final db = await database;
    return await db.update('signed_by', signedBy.toMap(), where: 'ID = ?', whereArgs: [signedBy.id]);
  }

  Future<int> deleteSignedBy(int id) async {
    final db = await database;
    return await db.delete('signed_by', where: 'ID = ?', whereArgs: [id]);
  }

  // Status
  Future<int> insertStatus(Status status) async {
    final db = await database;
    return await db.insert('status', status.toMap());
  }

  Future<List<Status>> getStatuses() async {
    final db = await database;
    final maps = await db.query('status');
    return maps.map((map) => Status.fromMap(map)).toList();
  }

  Future<Status?> getStatusById(int id) async {
    final db = await database;
    final maps = await db.query('status', where: 'ID = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Status.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateStatus(Status status) async {
    final db = await database;
    return await db.update('status', status.toMap(), where: 'ID = ?', whereArgs: [status.id]);
  }

  Future<int> deleteStatus(int id) async {
    final db = await database;
    return await db.delete('status', where: 'ID = ?', whereArgs: [id]);
  }

  // ======================== Расширенные методы для документов ========================

  /// Получает полный документ со всеми связанными данными
  Future<RusLawDocument?> getFullDocumentById(int id) async {
    final db = await database;

    // Получаем основной документ
    final documentMaps = await db.query(
      'rus_law_document',
      where: 'ID = ?',
      whereArgs: [id],
    );

    if (documentMaps.isEmpty) return null;
    final document = RusLawDocument.fromMap(documentMaps.first);

    // Получаем связанные данные
    final docType = await getDocumentTypeById(document.docTypeID!);
    final status = await getStatusById(document.statusID!);
    final author = await getAuthorById(document.authorID!);
    final issuedBy = await getIssuedByById(document.issuedByID!);
    final signedBy = await getSignedByById(document.signedByID!);
    final text = await getTextByDocumentId(document.id!);
    final keywords = await getKeywordsForDocument(document.id!);
    final classifiers = await getClassifiersForDocument(document.id!);

    return document.copyWith(
      docType: docType,
      status: status,
      author: author,
      issuedBy: issuedBy,
      signedBy: signedBy,
      text: text?.text,
      keywords: keywords,
      classifiers: classifiers,
    );
  }

  /// Поиск документов по различным критериям
  Future<List<RusLawDocument>> searchDocuments({
    String? title,
    String? docNumber,
    String? docDateFrom,
    String? docDateTo,
    int? docTypeId,
    int? statusId,
    int? authorId,
    bool? isWidelyUsed,
    bool? isPinned,
    List<int>? keywordIds,
  }) async {
    final db = await database;
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (title != null) {
      where.add('title LIKE ?');
      whereArgs.add('%$title%');
    }
    if (docNumber != null) {
      where.add('docNumber LIKE ?');
      whereArgs.add('%$docNumber%');
    }
    if (docDateFrom != null) {
      where.add('docDate >= ?');
      whereArgs.add(docDateFrom);
    }
    if (docDateTo != null) {
      where.add('docDate <= ?');
      whereArgs.add(docDateTo);
    }
    if (docTypeId != null) {
      where.add('docTypeID = ?');
      whereArgs.add(docTypeId);
    }
    if (statusId != null) {
      where.add('statusID = ?');
      whereArgs.add(statusId);
    }
    if (authorId != null) {
      where.add('authorID = ?');
      whereArgs.add(authorId);
    }
    if (isWidelyUsed != null) {
      where.add('isWidelyUsed = ?');
      whereArgs.add(isWidelyUsed ? 1 : 0);
    }
    if (isPinned != null) {
      where.add('isPinned = ?');
      whereArgs.add(isPinned ? 1 : 0);
    }

    // Базовый запрос документов
    var documents = await db.query(
      'rus_law_document',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    // Фильтрация по ключевым словам, если указаны
    if (keywordIds != null && keywordIds.isNotEmpty) {
      final keywordPlaceholders = List.filled(keywordIds.length, '?').join(',');
      final documentIdsWithKeywords = await db.rawQuery('''
        SELECT DISTINCT documentID 
        FROM rus_law_keyword 
        WHERE keywordID IN ($keywordPlaceholders)
      ''', keywordIds);

      if (documentIdsWithKeywords.isNotEmpty) {
        final ids = documentIdsWithKeywords.map((e) => e['documentID'] as int).toList();
        documents = documents.where((doc) => ids.contains(doc['ID'])).toList();
      } else {
        return [];
      }
    }

    return documents.map((map) => RusLawDocument.fromMap(map)).toList();
  }

  /// Получает ключевые слова для документа
  Future<List<Keyword>> getKeywordsForDocument(int documentId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT k.* 
      FROM keyword k
      JOIN rus_law_keyword rlk ON k.ID = rlk.keywordID
      WHERE rlk.documentID = ?
    ''', [documentId]);
    return maps.map((map) => Keyword.fromMap(map)).toList();
  }

  /// Получает классификаторы для документа
  Future<List<Classifier>> getClassifiersForDocument(int documentId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT c.* 
      FROM classifier c
      JOIN rus_law_reference rlr ON c.ID = rlr.classifierID
      WHERE rlr.documentID = ?
    ''', [documentId]);
    return maps.map((map) => Classifier.fromMap(map)).toList();
  }

  /// Получает текст документа
  Future<RusLawText?> getTextByDocumentId(int documentId) async {
    final db = await database;
    final maps = await db.query(
      'rus_law_text',
      where: 'documentID = ?',
      whereArgs: [documentId],
    );
    return maps.isNotEmpty ? RusLawText.fromMap(maps.first) : null;
  }

  /// Обновляет только флаг isPinned у документа
  Future<int> toggleDocumentPin(int documentId, bool isPinned) async {
    final db = await database;
    return await db.update(
      'rus_law_document',
      {'isPinned': isPinned ? 1 : 0},
      where: 'ID = ?',
      whereArgs: [documentId],
    );
  }

  /// Получает закрепленные документы
  Future<List<RusLawDocument>> getPinnedDocuments() async {
    final db = await database;
    final maps = await db.query(
      'rus_law_document',
      where: 'isPinned = ?',
      whereArgs: [1],
    );
    return maps.map((map) => RusLawDocument.fromMap(map)).toList();
  }

  /// Получает документы по типу
  Future<List<RusLawDocument>> getDocumentsByType(int docTypeId) async {
    final db = await database;
    final maps = await db.query(
      'rus_law_document',
      where: 'docTypeID = ?',
      whereArgs: [docTypeId],
    );
    return maps.map((map) => RusLawDocument.fromMap(map)).toList();
  }

  // ======================== Методы для работы с транзакциями ========================

  /// Сохраняет полный документ со всеми связанными данными в транзакции
  Future<int> saveFullDocument(RusLawDocument document) async {
    final db = await database;
    int documentId = document.id ?? 0;

    await db.transaction((txn) async {
      // Сохраняем основной документ
      if (documentId == 0) {
        documentId = await txn.insert('rus_law_document', document.toMap());
      } else {
        await txn.update(
          'rus_law_document',
          document.toMap(),
          where: 'ID = ?',
          whereArgs: [documentId],
        );
      }

      // Сохраняем текст
      if (document.text != null) {
        final text = RusLawText(
          documentID: documentId,
          text: document.text!,
        );
        await txn.insert(
          'rus_law_text',
          text.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Сохраняем ключевые слова
      if (document.keywords != null && document.keywords!.isNotEmpty) {
        // Удаляем старые связи
        await txn.delete(
          'rus_law_keyword',
          where: 'documentID = ?',
          whereArgs: [documentId],
        );

        // Добавляем новые
        for (final keyword in document.keywords!) {
          await txn.insert(
            'rus_law_keyword',
            RusLawKeyword(
              documentID: documentId,
              keywordID: keyword.id!,
            ).toMap(),
          );
        }
      }

      // Сохраняем классификаторы
      if (document.classifiers != null && document.classifiers!.isNotEmpty) {
        // Удаляем старые связи
        await txn.delete(
          'rus_law_reference',
          where: 'documentID = ?',
          whereArgs: [documentId],
        );

        // Добавляем новые
        for (final classifier in document.classifiers!) {
          await txn.insert(
            'rus_law_reference',
            RusLawReference(
              documentID: documentId,
              classifierID: classifier.id!,
            ).toMap(),
          );
        }
      }
    });

    return documentId;
  }

  /// Удаляет документ и все его связи (но не удаляет связанные сущности)
  Future<int> deleteDocumentWithRelations(int documentId) async {
    final db = await database;
    return await db.transaction((txn) async {
      // Удаляем связи с ключевыми словами
      await txn.delete(
        'rus_law_keyword',
        where: 'documentID = ?',
        whereArgs: [documentId],
      );

      // Удаляем связи с классификаторами
      await txn.delete(
        'rus_law_reference',
        where: 'documentID = ?',
        whereArgs: [documentId],
      );

      // Удаляем текст
      await txn.delete(
        'rus_law_text',
        where: 'documentID = ?',
        whereArgs: [documentId],
      );

      // Удаляем сам документ
      return await txn.delete(
        'rus_law_document',
        where: 'ID = ?',
        whereArgs: [documentId],
      );
    });
  }

  // ======================== Статистические методы ========================

  /// Получает количество документов по типам
  Future<Map<int, int>> getDocumentsCountByType() async {
    final db = await database;
    final result = <int, int>{};
    final maps = await db.rawQuery('''
      SELECT docTypeID, COUNT(*) as count 
      FROM rus_law_document 
      GROUP BY docTypeID
    ''');

    for (final map in maps) {
      result[map['docTypeID'] as int] = map['count'] as int;
    }

    return result;
  }

  /// Получает самые популярные ключевые слова
  Future<List<Map<String, dynamic>>> getPopularKeywords({int limit = 10}) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT k.ID, k.keyword, COUNT(rlk.documentID) as count
      FROM keyword k
      JOIN rus_law_keyword rlk ON k.ID = rlk.keywordID
      GROUP BY k.ID, k.keyword
      ORDER BY count DESC
      LIMIT ?
    ''', [limit]);
  }

  // Закрытие базы
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}