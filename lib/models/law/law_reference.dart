import '../models.dart';

class LawReference implements DbModel {
  @override
  final int id;
  final int sourceDocumentId;
  final int targetDocumentId;
  final int referenceTypeId;

  LawReference({
    required this.id,
    required this.sourceDocumentId,
    required this.targetDocumentId,
    required this.referenceTypeId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'sourceDocumentID': sourceDocumentId,
      'targetDocumentID': targetDocumentId,
      'referenceTypeID': referenceTypeId,
    };
  }

  factory LawReference.fromMap(Map<String, dynamic> map) {
    return LawReference(
      id: map['ID'] as int,
      sourceDocumentId: map['sourceDocumentID'] as int,
      targetDocumentId: map['targetDocumentID'] as int,
      referenceTypeId: map['referenceTypeID'] as int,
    );
  }
}