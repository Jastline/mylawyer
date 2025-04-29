import 'base_model.dart';

class DocumentType extends BaseModel {
  final String docType;

  DocumentType({int? id, required this.docType}) : super(id: id);

  factory DocumentType.fromMap(Map<String, dynamic> map) => DocumentType(
    id: map['ID'],
    docType: map['docType'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'docType': docType,
  };
}
