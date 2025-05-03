import 'models.dart';
import 'dart:typed_data';

class RusLawText extends BaseModel {
  final int documentID;
  final Uint8List text; // BLOB

  RusLawText({
    required int id,
    required this.documentID,
    required this.text,
  }) : super(id: id);

  factory RusLawText.fromMap(Map<String, dynamic> map) {
    return RusLawText(
      id: map['ID'],
      documentID: map['documentID'],
      text: map['text'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentID,
      'text': text,
    };
  }
}