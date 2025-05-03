import 'models.dart';

class Keyword extends BaseModel {
  final String keyword;

  Keyword({
    required int id,
    required this.keyword,
  }) : super(id: id);

  factory Keyword.fromMap(Map<String, dynamic> map) {
    return Keyword(
      id: map['ID'],
      keyword: map['keyword'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'keyword': keyword,
    };
  }
}