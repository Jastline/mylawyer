import 'package:flutter_test/flutter_test.dart';
import 'package:mylawyer/models/base/db_helper.dart';

void main() {
  group('CRUD tests', () {
    test('Insert and retrieve document type', () async {
      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Вставляем новый тип документа
      //await dbHelper._insertDocumentType(db, 'New Document Type');

      // Проверяем, что тип документа был добавлен
      var result = await db.query('document_type', where: 'docType = ?', whereArgs: ['New Document Type']);
      expect(result.isNotEmpty, true);
      expect(result.first['docType'], 'New Document Type');
    });

    test('Insert and retrieve user profile', () async {
      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Вставляем новый профиль пользователя
      await db.insert('user_profile', {'name': 'John Doe'});

      // Проверяем, что профиль был добавлен
      var result = await db.query('user_profile', where: 'name = ?', whereArgs: ['John Doe']);
      expect(result.isNotEmpty, true);
      expect(result.first['name'], 'John Doe');
    });
  });
}
