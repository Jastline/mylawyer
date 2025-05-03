import 'models.dart';

class DocumentType extends BaseModel {
  final String docType;

  DocumentType({
    required int id,
    required this.docType,
  }) : super(id: id);

  factory DocumentType.fromMap(Map<String, dynamic> map) {
    return DocumentType(
      id: map['ID'],
      docType: map['docType'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'docType': docType,
    };
  }
}