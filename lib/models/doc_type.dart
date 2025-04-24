class DocType {
  final int id;
  final String docType;

  DocType({
    required this.id,
    required this.docType,
  });

  factory DocType.fromMap(Map<String, dynamic> map) {
    return DocType(
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
