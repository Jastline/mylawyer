import 'package:flutter_test/flutter_test.dart';
import 'package:mylawyer/models/base/db_helper.dart';

void main() {
  group('Foreign key tests', () {
    test('Deleting document removes related rows', () async {
      final dbHelper = DatabaseHelper();
      final db = await dbHelper.database;

      // Вставляем данные в таблицы
      //final docTypeId = await dbHelper._getOrCreateDocumentType(db, 'Test Doc');
      await db.insert('rus_law_document', {
        'title': 'Test Document',
        'docDate': '2025-04-28',
        //'docTypeID': docTypeId,
        'statusID': 1,
        'authorID': 1,
        'issuedByID': 1,
        'signedByID': 1,
      });

      // Вставляем связанный текст
      final docId = await db.rawInsert('SELECT last_insert_rowid()');
      await db.insert('rus_law_text', {'documentID': docId, 'text': 'Test text'});

      // Проверяем, что текст был добавлен
      var result = await db.query('rus_law_text', where: 'documentID = ?', whereArgs: [docId]);
      expect(result.isNotEmpty, true);

      // Удаляем документ
      await db.delete('rus_law_document', where: 'ID = ?', whereArgs: [docId]);

      // Проверяем, что текст был удален
      result = await db.query('rus_law_text', where: 'documentID = ?', whereArgs: [docId]);
      expect(result.isEmpty, true);
    });
  });
}
