import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static const String _dbName = 'law_database.db';
  static const int _partsCount = 10;
  static const String _partPrefix = 'law_database_part';

  Future<Database> initialize() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

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
    }
  }

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
  }
}