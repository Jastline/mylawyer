import '../base/db_model.dart';
import 'package:sqflite/sqflite.dart';

class Classifier implements DbModel {
  @override
  final int id;
  final String classifier;

  Classifier({
    required this.id,
    this.classifier = 'Неизвестно',
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'classifier': classifier,
    };
  }

  factory Classifier.fromMap(Map<String, dynamic> map) {
    return Classifier(
      id: map['ID'] as int,
      classifier: map['classifier'] as String? ?? 'Неизвестно',
    );
  }

  static Future<void> seed(Database db) async {
    await db.insert(
      'classifier',
      {'ID': 1, 'classifier': 'Неизвестно'},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}