class DocumentLink {
  final int id;
  final int sourceDocumentId;
  final int targetDocumentId;
  final int typeLinkId;

  DocumentLink({
    required this.id,
    required this.sourceDocumentId,
    required this.targetDocumentId,
    required this.typeLinkId,
  });

  factory DocumentLink.fromMap(Map<String, dynamic> map) {
    return DocumentLink(
      id: map['ID'],
      sourceDocumentId: map['sourceDocumentID'],
      targetDocumentId: map['targetDocumentID'],
      typeLinkId: map['typeLinkID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'sourceDocumentID': sourceDocumentId,
      'targetDocumentID': targetDocumentId,
      'typeLinkID': typeLinkId,
    };
  }
}