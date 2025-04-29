import 'base_model.dart';

class RusLawText extends BaseModel {
  final int documentID;
  final String text;

  RusLawText({
    int? id,
    required this.documentID,
    required this.text,
  }) : super(id: id);

  factory RusLawText.fromMap(Map<String, dynamic> map) => RusLawText(
    id: map['ID'],
    documentID: map['documentID'],
    text: map['text'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'documentID': documentID,
    'text': text,
  };
}
