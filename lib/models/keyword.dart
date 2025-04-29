import 'base_model.dart';

class Keyword extends BaseModel {
  final String keyword;

  Keyword({int? id, required this.keyword}) : super(id: id);

  factory Keyword.fromMap(Map<String, dynamic> map) => Keyword(
    id: map['ID'],
    keyword: map['keyword'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'keyword': keyword,
  };
}
