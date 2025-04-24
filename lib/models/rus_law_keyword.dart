class RusLawKeyword {
  final int id;
  final int documentID;
  final int keywordID;

  RusLawKeyword({
    required this.id,
    required this.documentID,
    required this.keywordID,
  });

  factory RusLawKeyword.fromMap(Map<String, dynamic> map) {
    return RusLawKeyword(
      id: map['ID'],
      documentID: map['documentID'],
      keywordID: map['keywordID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentID,
      'keywordID': keywordID,
    };
  }
}
