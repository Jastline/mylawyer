import '../base/db_model.dart';

class UserDocument implements DbModel {
  final int id;
  final int documentId;
  final int userId;
  final bool pinned;
  final DateTime readAt;
  final String pathReadDB;

  UserDocument({
    required this.id,
    required this.documentId,
    required this.userId,
    this.pinned = false,
    required this.readAt,
    required this.pathReadDB,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'documentID': documentId,
      'userID': userId,
      'pinned': pinned ? 1 : 0,
      'readAt': readAt.toIso8601String(),
      'pathReadDB': pathReadDB,
    };
  }

  static UserDocument fromMap(Map<String, dynamic> map) {
    return UserDocument(
      id: map['ID'] as int,
      documentId: map['documentID'] as int,
      userId: map['userID'] as int,
      pinned: map['pinned'] == 1,
      readAt: DateTime.parse(map['readAt'] as String),
      pathReadDB: map['pathReadDB'] as String,
    );
  }
}