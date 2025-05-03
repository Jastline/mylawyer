import 'models.dart';

class Author extends BaseModel {
  final String author;

  Author({
    required int id,
    required this.author,
  }) : super(id: id);

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['ID'],
      author: map['author'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'author': author,
    };
  }
}