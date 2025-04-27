import '../base/db_model.dart';

class LawDocumentKeyword implements DbModel {
  @override
  final int id;
  final int documentId;
  final int keywordId;

  LawDocumentKeyword({
    required this.id,
    required this.documentId,
    required this.keywordId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'keywordID': keywordId,
    };
  }

  factory LawDocumentKeyword.fromMap(Map<String, dynamic> map) {
    return LawDocumentKeyword(
      id: map['ID'] as int,
      documentId: map['documentID'] as int,
      keywordId: map['keywordID'] as int,
    );
  }
}