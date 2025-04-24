class RusLawReference {
  final int id;
  final int documentID;
  final int classifierID;

  RusLawReference({
    required this.id,
    required this.documentID,
    required this.classifierID,
  });

  factory RusLawReference.fromMap(Map<String, dynamic> map) {
    return RusLawReference(
      id: map['ID'],
      documentID: map['documentID'],
      classifierID: map['classifierID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentID,
      'classifierID': classifierID,
    };
  }
}
