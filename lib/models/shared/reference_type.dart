import '../base/db_model.dart';
import 'package:sqflite/sqflite.dart';

class ReferenceType implements DbModel {
  @override
  final int id;
  final String referenceType;

  ReferenceType({
    required this.id,
    this.referenceType = 'Неизвестно',
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'referenceType': referenceType,
    };
  }

  factory ReferenceType.fromMap(Map<String, dynamic> map) {
    return ReferenceType(
      id: map['ID'] as int,
      referenceType: map['referenceType'] as String? ?? 'Неизвестно',
    );
  }

  static Future<void> seed(Database db) async {
    await db.insert(
      'reference_type',
      {'ID': 1, 'referenceType': 'Неизвестно'},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}