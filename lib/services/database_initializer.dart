import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static const String _dbName = 'law_database.db';
  static const String _dbAssetPath = 'assets/database/$_dbName';

  Future<Database> initialize() async {
    // Путь к конечной БД в файловой системе
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    // Проверяем, существует ли уже БД
    final exists = await databaseExists(path);

    if (!exists) {
      try {
        // Создаем директорию, если ее нет
        await Directory(dirname(path)).create(recursive: true);

        // Копируем БД из assets
        final ByteData data = await rootBundle.load(_dbAssetPath);
        final bytes = data.buffer.asUint8List();

        // Записываем файл
        await File(path).writeAsBytes(bytes, flush: true);

        // Проверяем размер БД (для отладки)
        final file = File(path);
        final sizeInMB = file.lengthSync() / (1024 * 1024);
        print('БД скопирована. Размер: ${sizeInMB.toStringAsFixed(2)} МБ');
      } catch (e) {
        throw Exception('Ошибка копирования БД: $e');
      }
    }

    // Открываем БД с настройками
    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onOpen: _onOpen,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Включаем поддержку FOREIGN KEY (если не включено в самой БД)
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onOpen(Database db) async {
    // Проверяем целостность БД (опционально)
    final integrity = await db.rawQuery('PRAGMA quick_check;');
    print('Проверка целостности БД: $integrity');
  }
}