class TestModel {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String lawReference;

  TestModel({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.lawReference,
  });
}
