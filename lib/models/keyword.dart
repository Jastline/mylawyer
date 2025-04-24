class Keyword {
  final int id;
  final String keyword;

  Keyword({
    required this.id,
    required this.keyword,
  });

  factory Keyword.fromMap(Map<String, dynamic> map) {
    return Keyword(
      id: map['ID'],
      keyword: map['keyword'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'keyword': keyword,
    };
  }
}
