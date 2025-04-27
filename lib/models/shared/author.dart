import '../base/db_model.dart';

class Author implements DbModel {
  @override
  final int id;
  final String author;

  Author({
    required this.id,
    required this.author,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'author': author,
    };
  }

  static Author fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['ID'] as int,
      author: map['author'] as String,
    );
  }
}