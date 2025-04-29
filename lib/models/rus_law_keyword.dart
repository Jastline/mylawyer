import 'base_model.dart';

class RusLawKeyword extends BaseModel {
  final int documentID;
  final int keywordID;

  RusLawKeyword({
    int? id,
    required this.documentID,
    required this.keywordID,
  }) : super(id: id);

  factory RusLawKeyword.fromMap(Map<String, dynamic> map) => RusLawKeyword(
    id: map['ID'],
    documentID: map['documentID'],
    keywordID: map['keywordID'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'documentID': documentID,
    'keywordID': keywordID,
  };
}
