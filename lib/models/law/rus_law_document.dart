class RusLawDocument {
  final int id;
  final String title;
  final String docDate;
  final String docNumber;
  final int internalNumber;
  final bool isWidelyUsed;
  final int docTypeID;
  final int statusId;
  final int authorId;
  final int issuedById;
  final int signedById;

  RusLawDocument({
    required this.id,
    required this.title,
    required this.docDate,
    required this.docNumber,
    required this.internalNumber,
    required this.isWidelyUsed,
    required this.docTypeID,
    required this.statusId,
    required this.authorId,
    required this.issuedById,
    required this.signedById,
  });

  factory RusLawDocument.fromMap(Map<String, dynamic> map) {
    return RusLawDocument(
      id: map['ID'],
      title: map['title'],
      docDate: map['docDate'],
      docNumber: map['docNumber'],
      internalNumber: map['internalNumber'],
      isWidelyUsed: map['isWidelyUsed'],
      docTypeID: map['docTypeID'],
      statusId: map['statusID'],
      authorId: map['authorID'],
      issuedById: map['issuedByID'],
      signedById: map['signedByID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'docDate': docDate,
      'docNumber': docNumber,
      'internalNumber': internalNumber,
      'isWidelyUsed': isWidelyUsed,
      'statusID': statusId,
      'docTypeID': docTypeID,
      'authorID': authorId,
      'issuedByID': issuedById,
      'signedByID': signedById,
    };
  }
}