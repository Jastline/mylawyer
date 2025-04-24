class RusLawDocumentLink {
  final int id;
  final int sourceDocumentID;
  final int targetDocumentID;
  final int referenceTypeID;

  RusLawDocumentLink({
    required this.id,
    required this.sourceDocumentID,
    required this.targetDocumentID,
    required this.referenceTypeID,
  });

  factory RusLawDocumentLink.fromMap(Map<String, dynamic> map) {
    return RusLawDocumentLink(
      id: map['ID'],
      sourceDocumentID: map['sourceDocumentID'],
      targetDocumentID: map['targetDocumentID'],
      referenceTypeID: map['referenceTypeID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'sourceDocumentID': sourceDocumentID,
      'targetDocumentID': targetDocumentID,
      'referenceTypeID': referenceTypeID,
    };
  }
}
