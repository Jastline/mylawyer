class RusLawReference {
  final int id;
  final int documentId;
  final int classifierId;

  RusLawReference({
    required this.id,
    required this.documentId,
    required this.classifierId,
  });

  factory RusLawReference.fromMap(Map<String, dynamic> map) {
    return RusLawReference(
      id: map['ID'],
      documentId: map['documentID'],
      classifierId: map['classifierID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'classifierID': classifierId,
    };
  }
}