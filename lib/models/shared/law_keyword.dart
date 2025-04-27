import '../base/db_model.dart';

class LawKeyword implements DbModel {
  @override
  final int id;
  final String keyword;

  LawKeyword({
    required this.id,
    required this.keyword,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'keyword': keyword,
    };
  }

  factory LawKeyword.fromMap(Map<String, dynamic> map) {
    return LawKeyword(
      id: map['ID'] as int,
      keyword: map['keyword'] as String,
    );
  }
}