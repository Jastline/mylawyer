import 'models.dart';

class IssuedBy extends BaseModel {
  final String issuedBy;

  IssuedBy({
    required int id,
    required this.issuedBy,
  }) : super(id: id);

  factory IssuedBy.fromMap(Map<String, dynamic> map) {
    return IssuedBy(
      id: map['ID'],
      issuedBy: map['issuedBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'issuedBy': issuedBy,
    };
  }
}