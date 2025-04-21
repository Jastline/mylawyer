class TestModel {
  final int? id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String lawReference;

  TestModel({
    this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.lawReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options.join('|'),
      'correctIndex': correctIndex,
      'lawReference': lawReference,
    };
  }

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'],
      question: map['question'],
      options: (map['options'] as String).split('|'),
      correctIndex: map['correctIndex'],
      lawReference: map['lawReference'],
    );
  }
}
