import 'base_model.dart';

class SignedBy extends BaseModel {
  final String signedBy;

  SignedBy({int? id, required this.signedBy}) : super(id: id);

  factory SignedBy.fromMap(Map<String, dynamic> map) => SignedBy(
    id: map['ID'],
    signedBy: map['signedBy'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'signedBy': signedBy,
  };
}
