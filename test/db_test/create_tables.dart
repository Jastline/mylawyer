import 'package:flutter_test/flutter_test.dart';
import 'package:mylawyer/models/base/db_helper.dart';

void main() {
  group('Database creation tests', () {
    test('All tables are created correctly', () async {
      final dbHelper = DatabaseHelper();

      // Получаем базу данных
      final db = await dbHelper.database;

      // Проверяем наличие всех таблиц
      var result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      List<String> tableNames = result.map((row) => row['name'] as String).toList();

      // Ожидаемые таблицы
      List<String> expectedTables = [
        'document_type',
        'status',
        'author',
        'issued_by',
        'signed_by',
        'keyword',
        'classifier',
        'link_type',
        'user_profile',
        'rus_law_document',
        'rus_law_text',
        'rus_law_keyword',
        'document_link',
        'document_user',
        'rus_law_reference'
      ];

      // Проверка, что все таблицы существуют
      for (var table in expectedTables) {
        expect(tableNames.contains(table), true);
      }
    });
  });
}
