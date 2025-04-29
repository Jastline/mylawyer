import 'base_model.dart';

class RusLawReference extends BaseModel {
  final int documentID;
  final int classifierID;

  RusLawReference({
    int? id,
    required this.documentID,
    required this.classifierID,
  }) : super(id: id);

  factory RusLawReference.fromMap(Map<String, dynamic> map) => RusLawReference(
    id: map['ID'],
    documentID: map['documentID'],
    classifierID: map['classifierID'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'documentID': documentID,
    'classifierID': classifierID,
  };
}
