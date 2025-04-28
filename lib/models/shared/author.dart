class Author {
  final int id;
  final String author;

  Author({
    required this.id,
    required this.author,
  });

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['ID'],
      author: map['author'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'author': author,
    };
  }
}