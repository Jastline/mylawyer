class DocumentUser {
  final int id;
  final int documentId;
  final int userId;
  final bool pinned;
  final String readAt;
  final String pathReadDB;

  DocumentUser({
    required this.id,
    required this.documentId,
    required this.userId,
    required this.pinned,
    required this.readAt,
    required this.pathReadDB,
  });

  factory DocumentUser.fromMap(Map<String, dynamic> map) {
    return DocumentUser(
      id: map['ID'],
      documentId: map['documentID'],
      userId: map['userID'],
      pinned: map['pinned'] == 1,
      readAt: map['readAt'],
      pathReadDB: map['pathReadDB'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'userID': userId,
      'pinned': pinned ? 1 : 0,
      'readAt': readAt,
      'pathReadDB': pathReadDB,
    };
  }
}