class RusLawText {
  final int id;
  final int documentID;
  final String text;

  RusLawText({
    required this.id,
    required this.documentID,
    required this.text,
  });

  factory RusLawText.fromMap(Map<String, dynamic> map) {
    return RusLawText(
      id: map['ID'],
      documentID: map['documentID'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentID,
      'text': text,
    };
  }
}
