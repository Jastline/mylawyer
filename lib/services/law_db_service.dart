import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LawDatabaseService {
  Database? _database;

  /// Открытие конкретной БД по параметрам
  Future<void> open({
    required bool isPopular,
    required String docType,
    required int year,
  }) async {
    final dbFolder = await getDatabasesPath();
    final category = isPopular ? 'Основной' : 'Дополнительный';
    final dbPath = join(
      dbFolder,
      'MyLawyer',
      category,
      docType,
      '$year.db',
    );

    if (!await File(dbPath).exists()) {
      throw Exception('БД не найдена по пути: $dbPath');
    }

    _database = await openDatabase(dbPath);
  }

  /// Закрыть БД
  Future<void> close() async {
    await _database?.close();
  }

  /// Пример: получить все документы
  Future<List<Map<String, dynamic>>> getAllDocuments() async {
    if (_database == null) throw Exception('БД не открыта');

    return await _database!.query('rus_law_document');
  }

  /// Пример: получить текст документа
  Future<String?> getFullTextByDocumentId(int documentId) async {
    if (_database == null) throw Exception('БД не открыта');

    final result = await _database!.query(
      'rus_law_text',
      where: 'documentID = ?',
      whereArgs: [documentId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['text'] as String?;
    }
    return null;
  }

/// TODO: сюда можно добавить остальные методы для связей, ссылок, авторов и т.п.
}
