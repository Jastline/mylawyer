import '../base/db_model.dart';

class LawText implements DbModel {
  @override
  final int id;
  final int documentId;
  final String text;

  LawText({
    required this.id,
    required this.documentId,
    required this.text,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'text': text,
    };
  }

  static LawText fromMap(Map<String, dynamic> map) {
    return LawText(
      id: map['ID'] as int,
      documentId: map['documentID'] as int,
      text: map['text'] as String,
    );
  }
}