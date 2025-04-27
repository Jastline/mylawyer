import '../base/db_model.dart';
import 'package:sqflite/sqflite.dart';

class Status implements DbModel {
  @override
  final int id;
  final String status;

  Status({
    required this.id,
    this.status = 'Неизвестно',
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'status': status,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['ID'] as int,
      status: map['status'] as String? ?? 'Неизвестно',
    );
  }

  static Future<void> seed(Database db) async {
    await db.insert(
      'status',
      {'ID': 1, 'status': 'Неизвестно'},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}