import '../base/db_model.dart';

class LawClassifier implements DbModel {
  @override
  final int id;
  final int documentId;
  final int classifierId;

  LawClassifier({
    required this.id,
    required this.documentId,
    required this.classifierId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'classifierID': classifierId,
    };
  }

  static LawClassifier fromMap(Map<String, dynamic> map) {
    return LawClassifier(
      id: map['ID'] as int,
      documentId: map['documentID'] as int,
      classifierId: map['classifierID'] as int,
    );
  }
}