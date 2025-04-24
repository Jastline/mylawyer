class RusLawDocument {
  final int id;
  final String title;
  final String docDate;
  final String docNumber;
  final bool isPopular;
  final int internalNumber;
  final int docTypeID;
  final int statusID;
  final int authorID;
  final int issuedByID;
  final int signedByID;

  RusLawDocument({
    required this.id,
    required this.title,
    required this.docDate,
    required this.docNumber,
    required this.isPopular,
    required this.internalNumber,
    required this.docTypeID,
    required this.statusID,
    required this.authorID,
    required this.issuedByID,
    required this.signedByID,
  });

  factory RusLawDocument.fromMap(Map<String, dynamic> map) {
    return RusLawDocument(
      id: map['ID'],
      title: map['title'],
      docDate: map['docDate'],
      docNumber: map['docNumber'],
      isPopular: map['isPopular'] == 1,
      internalNumber: map['internalNumber'],
      docTypeID: map['docType'],
      statusID: map['statusID'],
      authorID: map['authorID'],
      issuedByID: map['issuedByID'],
      signedByID: map['signedByID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'docDate': docDate,
      'docNumber': docNumber,
      'isPopular': isPopular ? 1 : 0,
      'internalNumber': internalNumber,
      'docTypeID': docTypeID,
      'statusID': statusID,
      'authorID': authorID,
      'issuedByID': issuedByID,
      'signedByID': signedByID,
    };
  }
}
