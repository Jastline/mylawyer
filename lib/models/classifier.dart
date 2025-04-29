import 'base_model.dart';

class Classifier extends BaseModel {
  final String classifier;

  Classifier({int? id, required this.classifier}) : super(id: id);

  factory Classifier.fromMap(Map<String, dynamic> map) => Classifier(
    id: map['ID'],
    classifier: map['classifier'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'classifier': classifier,
  };
}
