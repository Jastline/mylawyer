class DocumentType {
  final int id;
  final String docType;

  DocumentType({
    required this.id,
    required this.docType,
  });

  factory DocumentType.fromMap(Map<String, dynamic> map) {
    return DocumentType(
      id: map['ID'],
      docType: map['docType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'docType': docType,
    };
  }
}