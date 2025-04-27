import '../base/db_model.dart';

class Document implements DbModel {
  @override
  final int id;
  final String title;
  final String docDate;
  final String? docNumber;
  final int? internalNumber;
  final int statusId;
  final int authorId;
  final int issuedById;
  final int signedById;

  Document({
    required this.id,
    required this.title,
    required this.docDate,
    this.docNumber,
    this.internalNumber,
    this.statusId = -1,
    this.authorId = -1,
    this.issuedById = -1,
    this.signedById = -1,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'docDate': docDate,
      'docNumber': docNumber,
      'internalNumber': internalNumber,
      'statusID': statusId,
      'authorID': authorId,
      'issuedByID': issuedById,
      'signedByID': signedById,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['ID'] as int,
      title: map['title'] as String,
      docDate: map['docDate'] as String,
      docNumber: map['docNumber'] as String?,
      internalNumber: map['internalNumber'] as int?,
      statusId: map['statusID'] as int? ?? -1,
      authorId: map['authorID'] as int? ?? -1,
      issuedById: map['issuedByID'] as int? ?? -1,
      signedById: map['signedByID'] as int? ?? -1,
    );
  }
}