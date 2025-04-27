import '../base/db_model.dart';

class IssuedBy implements DbModel {
  @override
  final int id;
  final String issuedBy;

  IssuedBy({
    required this.id,
    required this.issuedBy,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'issuedBy': issuedBy,
    };
  }

  static IssuedBy fromMap(Map<String, dynamic> map) {
    return IssuedBy(
      id: map['ID'] as int,
      issuedBy: map['issuedBy'] as String,
    );
  }
}