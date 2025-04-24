class Classifier {
  final int id;
  final String classifier;

  Classifier({
    required this.id,
    required this.classifier,
  });

  factory Classifier.fromMap(Map<String, dynamic> map) {
    return Classifier(
      id: map['ID'],
      classifier: map['classifier'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'classifier': classifier,
    };
  }
}
