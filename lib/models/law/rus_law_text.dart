class RusLawText {
  final int id;
  final int documentId;
  final String text;

  RusLawText({
    required this.id,
    required this.documentId,
    required this.text,
  });

  factory RusLawText.fromMap(Map<String, dynamic> map) {
    return RusLawText(
      id: map['ID'],
      documentId: map['documentID'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'text': text,
    };
  }
}