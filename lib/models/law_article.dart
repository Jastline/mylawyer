class LawArticle {
  final int id;
  final String code; // например "ГК РФ", "Конституция"
  final String chapter; // Название главы или раздела
  final String articleNumber; // "ст. 17", "ст. 21"
  final String title;
  final String content;

  LawArticle({
    required this.id,
    required this.code,
    required this.chapter,
    required this.articleNumber,
    required this.title,
    required this.content,
  });

  factory LawArticle.fromMap(Map<String, dynamic> map) {
    return LawArticle(
      id: map['id'],
      code: map['code'],
      chapter: map['chapter'],
      articleNumber: map['articleNumber'],
      title: map['title'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'chapter': chapter,
      'articleNumber': articleNumber,
      'title': title,
      'content': content,
    };
  }
}
