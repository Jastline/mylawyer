class RusLawDocumentUser {
  final int id;
  final int documentID;
  final int userID;
  final bool pinned;
  final String readAt;
  final String pathReadDB;

  RusLawDocumentUser({
    required this.id,
    required this.documentID,
    required this.userID,
    required this.pinned,
    required this.readAt,
    required this.pathReadDB,
  });

  factory RusLawDocumentUser.fromMap(Map<String, dynamic> map) {
    return RusLawDocumentUser(
      id: map['ID'],
      documentID: map['documentID'],
      userID: map['userID'],
      pinned: map['pinned'] == 1,
      readAt: map['readAt'],
      pathReadDB: map['pathReadDB'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentID,
      'userID': userID,
      'pinned': pinned ? 1 : 0,
      'readAt': readAt,
      'pathReadDB': pathReadDB,
    };
  }
}
