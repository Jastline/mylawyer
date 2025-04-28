class RusLawKeyword {
  final int id;
  final int documentId;
  final int keywordId;

  RusLawKeyword({
    required this.id,
    required this.documentId,
    required this.keywordId,
  });

  factory RusLawKeyword.fromMap(Map<String, dynamic> map) {
    return RusLawKeyword(
      id: map['ID'],
      documentId: map['documentID'],
      keywordId: map['keywordID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'keywordID': keywordId,
    };
  }
}