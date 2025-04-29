import 'base_model.dart';

class IssuedBy extends BaseModel {
  final String issuedBy;

  IssuedBy({int? id, required this.issuedBy}) : super(id: id);

  factory IssuedBy.fromMap(Map<String, dynamic> map) => IssuedBy(
    id: map['ID'],
    issuedBy: map['issuedBy'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'issuedBy': issuedBy,
  };
}
