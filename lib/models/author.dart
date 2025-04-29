import 'base_model.dart';

class Author extends BaseModel {
  final String author;

  Author({int? id, required this.author}) : super(id: id);

  factory Author.fromMap(Map<String, dynamic> map) => Author(
    id: map['ID'],
    author: map['author'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'author': author,
  };
}
