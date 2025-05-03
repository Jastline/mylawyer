import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'database_initializer.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  final DatabaseInitializer _initializer = DatabaseInitializer();
  final Completer<Database> _databaseCompleter = Completer();

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (_databaseCompleter.isCompleted) {
      return _databaseCompleter.future;
    }

    try {
      _database = await _initializer.initialize();
      _databaseCompleter.complete(_database);
      return _database!;
    } catch (e) {
      _databaseCompleter.completeError(e);
      rethrow;
    }
  }

  // ======================== Основные методы для документов ========================

  /// Получает документ по ID с основными связанными данными
  Future<RusLawDocument?> getDocumentById(int id) async {
    final db = await database;

    final document = await db.query(
      'rus_law_document',
      where: 'ID = ?',
      whereArgs: [id],
    );

    if (document.isEmpty) return null;

    return RusLawDocument.fromMap(document.first);
  }

  /// Получает документ по номеру (docNumber)
  Future<RusLawDocument?> getDocumentByNumber(String docNumber) async {
    final db = await database;

    final document = await db.query(
      'rus_law_document',
      where: 'docNumber = ?',
      whereArgs: [docNumber],
    );

    if (document.isEmpty) return null;

    return RusLawDocument.fromMap(document.first);
  }

  /// Получает полный документ со всеми связанными данными
  Future<RusLawDocument?> getFullDocument(int id) async {
    final db = await database;

    return await db.transaction((txn) async {
      final document = await txn.query(
        'rus_law_document',
        where: 'ID = ?',
        whereArgs: [id],
      );

      if (document.isEmpty) return null;
      final doc = RusLawDocument.fromMap(document.first);

      // Получаем связанные данные
      final text = await _getDocumentText(txn, id);
      final keywords = await _getDocumentKeywords(txn, id);
      final docType = await _getDocumentType(txn, doc.docTypeID);
      final status = await _getDocumentStatus(txn, doc.statusID);
      final author = await _getDocumentAuthor(txn, doc.authorID);
      final issuedBy = await _getDocumentIssuedBy(txn, doc.issuedByID);
      final signedBy = await _getDocumentSignedBy(txn, doc.signedByID);

      return doc.copyWith(
        text: text,
        keywords: keywords,
        docType: docType?.docType,
        status: status?.status,
        author: author?.author,
        issuedBy: issuedBy?.issuedBy,
        signedBy: signedBy?.signedBy,
      );
    });
  }

  /// Получает текст документа
  Future<String?> getDocumentText(int documentId) async {
    final db = await database;
    try {
      final result = await db.query(
        'rus_law_text',
        where: 'documentID = ?',
        whereArgs: [documentId],
      );

      if (result.isEmpty) return null;

      // Вариант 1: Если текст хранится как BLOB
      if (result.first['text'] is Uint8List) {
        return utf8.decode(result.first['text'] as Uint8List);
      }

      // Вариант 2: Если текст хранится как строка
      return result.first['text'] as String?;
    } catch (e) {
      debugPrint('Ошибка получения текста документа: $e');
      return null;
    }
  }

  /// Получает все типы документов
  Future<List<DocumentType>> getDocumentTypes() async {
    final db = await database;
    final result = await db.query('document_type');
    return result.map((e) => DocumentType.fromMap(e)).toList();
  }

  /// Обновляет флаг isPinned
  Future<int> togglePinStatus(int documentId, bool isPinned) async {
    final db = await database;
    return await db.update(
      'rus_law_document',
      {'isPinned': isPinned ? 1 : 0},
      where: 'ID = ?',
      whereArgs: [documentId],
    );
  }

  /// Получает все закрепленные документы
  Future<List<RusLawDocument>> getPinnedDocuments() async {
    final db = await database;
    final result = await db.query(
      'rus_law_document',
      where: 'isPinned = ?',
      whereArgs: [1],
    );

    return result.map((e) => RusLawDocument.fromMap(e)).toList();
  }

  // ======================== Методы поиска ========================

  /// Полнотекстовый поиск по документам
  Future<List<RusLawDocument>> searchDocuments({
    String? query,
    List<int>? typeIds,
    List<int>? statusIds,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? isPinned,
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await database;
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (query != null && query.isNotEmpty) {
      where.add('''
        (title LIKE ? OR docNumber LIKE ? OR EXISTS (
          SELECT 1 FROM rus_law_text 
          WHERE documentID = rus_law_document.ID 
          AND text LIKE ?
        ))
      ''');
      whereArgs.addAll(['%$query%', '%$query%', '%$query%']);
    }

    if (typeIds != null && typeIds.isNotEmpty) {
      where.add('docTypeID IN (${List.filled(typeIds.length, '?').join(',')})');
      whereArgs.addAll(typeIds);
    }

    if (statusIds != null && statusIds.isNotEmpty) {
      where.add('statusID IN (${List.filled(statusIds.length, '?').join(',')})');
      whereArgs.addAll(statusIds);
    }

    if (dateFrom != null) {
      where.add('docDate >= ?');
      whereArgs.add(dateFrom.toIso8601String());
    }

    if (dateTo != null) {
      where.add('docDate <= ?');
      whereArgs.add(dateTo.toIso8601String());
    }

    if (isPinned != null) {
      where.add('isPinned = ?');
      whereArgs.add(isPinned ? 1 : 0);
    }

    final result = await db.query(
      'rus_law_document',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
    );

    return result.map((e) => RusLawDocument.fromMap(e)).toList();
  }

  /// Поиск документов по ключевым словам
  Future<List<RusLawDocument>> searchByKeywords(List<int> keywordIds) async {
    if (keywordIds.isEmpty) return [];

    final db = await database;
    final placeholders = List.filled(keywordIds.length, '?').join(',');

    final result = await db.rawQuery('''
      SELECT DISTINCT rld.* FROM rus_law_document rld
      JOIN rus_law_keyword rlk ON rld.ID = rlk.documentID
      WHERE rlk.keywordID IN ($placeholders)
    ''', keywordIds);

    return result.map((e) => RusLawDocument.fromMap(e)).toList();
  }

  // ======================== Методы для работы с ссылками ========================

  /// Проверяет существование документа по номеру
  Future<bool> documentExists(String docNumber) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT 1 FROM rus_law_document WHERE docNumber = ? LIMIT 1',
      [docNumber],
    );
    return result.isNotEmpty;
  }

  /// Получает все ссылки из текста документа
  Future<List<String>> extractReferences(int documentId) async {
    final text = await getDocumentText(documentId);
    if (text == null) return [];

    final regex = RegExp(r'<ref\s*=\s*([^>]+)>');
    return regex.allMatches(text).map((m) => m.group(1)!).toList();
  }

  // ======================== Вспомогательные методы ========================

  Future<String?> _getDocumentText(Transaction txn, int documentId) async {
    final result = await txn.query(
      'rus_law_text',
      where: 'documentID = ?',
      whereArgs: [documentId],
    );
    return result.isNotEmpty
        ? String.fromCharCodes(result.first['text'] as Uint8List)
        : null;
  }

  Future<List<Keyword>> _getDocumentKeywords(Transaction txn, int documentId) async {
    final result = await txn.rawQuery('''
      SELECT k.* FROM keyword k
      JOIN rus_law_keyword rlk ON k.ID = rlk.keywordID
      WHERE rlk.documentID = ?
    ''', [documentId]);

    return result.map((e) => Keyword.fromMap(e)).toList();
  }

  Future<DocumentType?> _getDocumentType(Transaction txn, int? typeId) async {
    if (typeId == null) return null;
    final result = await txn.query(
      'document_type',
      where: 'ID = ?',
      whereArgs: [typeId],
    );
    return result.isNotEmpty ? DocumentType.fromMap(result.first) : null;
  }

  Future<Status?> _getDocumentStatus(Transaction txn, int? statusId) async {
    if (statusId == null) return null;
    final result = await txn.query(
      'status',
      where: 'ID = ?',
      whereArgs: [statusId],
    );
    return result.isNotEmpty ? Status.fromMap(result.first) : null;
  }

  Future<Author?> _getDocumentAuthor(Transaction txn, int? authorId) async {
    if (authorId == null) return null;
    final result = await txn.query(
      'author',
      where: 'ID = ?',
      whereArgs: [authorId],
    );
    return result.isNotEmpty ? Author.fromMap(result.first) : null;
  }

  Future<IssuedBy?> _getDocumentIssuedBy(Transaction txn, int? issuedById) async {
    if (issuedById == null) return null;
    final result = await txn.query(
      'issued_by',
      where: 'ID = ?',
      whereArgs: [issuedById],
    );
    return result.isNotEmpty ? IssuedBy.fromMap(result.first) : null;
  }

  Future<SignedBy?> _getDocumentSignedBy(Transaction txn, int? signedById) async {
    if (signedById == null) return null;
    final result = await txn.query(
      'signed_by',
      where: 'ID = ?',
      whereArgs: [signedById],
    );
    return result.isNotEmpty ? SignedBy.fromMap(result.first) : null;
  }

  // ======================== Методы для работы с БД ========================

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}