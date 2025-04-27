import '../base/db_model.dart';

class SignedBy implements DbModel {
  @override
  final int id;
  final String signedBy;

  SignedBy({
    required this.id,
    required this.signedBy,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'signedBy': signedBy,
    };
  }

  static SignedBy fromMap(Map<String, dynamic> map) {
    return SignedBy(
      id: map['ID'] as int,
      signedBy: map['signedBy'] as String,
    );
  }
}