import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static const String _dbName = 'law_database.db';
<<<<<<< HEAD
  static const String _dbAssetPath = 'assets/database/$_dbName';
=======
  static const int _partsCount = 10;
  static const String _partPrefix = 'law_database_part';
>>>>>>> parent of 00b0b33 (million musora)

  Future<Database> initialize() async {
    // Путь к конечной БД в файловой системе
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

<<<<<<< HEAD
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
=======
    if (!await databaseExists(path)) {
      await _combineDatabaseParts(path);
      await _validateDatabase(path);
    }

    return await openDatabase(path);
  }

  Future<void> _combineDatabaseParts(String outputPath) async {
    final file = File(outputPath);
    if (await file.exists()) await file.delete();

    final sink = file.openWrite(mode: FileMode.writeOnly);

    try {
      for (int i = 1; i <= _partsCount; i++) {
        final partName = '$_partPrefix$i.db';
        print('Loading part $i/$_partsCount: $partName'); // Заменено debugPrint на print

        try {
          final data = await rootBundle.load(join('assets', 'database', partName));
          // Исправлено: прямое использование Uint8List без .stream
          sink.add(data.buffer.asUint8List());
          await sink.flush();
        } catch (e) {
          await sink.close();
          await file.delete();
          throw Exception('Failed to load part $i: $e');
        }
      }
    } catch (e) {
      await sink.close();
      await file.delete();
      rethrow;
    } finally {
      await sink.close();
>>>>>>> parent of 00b0b33 (million musora)
    }

    // Открываем БД с настройками
    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onOpen: _onOpen,
    );
  }

<<<<<<< HEAD
  Future<void> _onConfigure(Database db) async {
    // Включаем поддержку FOREIGN KEY (если не включено в самой БД)
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onOpen(Database db) async {
    // Проверяем целостность БД (опционально)
    final integrity = await db.rawQuery('PRAGMA quick_check;');
    print('Проверка целостности БД: $integrity');
=======
  Future<bool> _validateDatabase(String path) async {
    Database? db;
    try {
      db = await openDatabase(path);
      final result = await db.rawQuery('PRAGMA integrity_check;');
      if (result.isNotEmpty && result.first['integrity_check'] == 'ok') {
        return true;
      }
      throw Exception('Database integrity check failed: $result');
    } catch (e) {
      await db?.close();
      await File(path).delete();
      throw Exception('Database validation failed: $e');
    } finally {
      await db?.close();
    }
>>>>>>> parent of 00b0b33 (million musora)
  }
}