import 'models.dart';

class SignedBy extends BaseModel {
  final String signedBy;

  SignedBy({
    required int id,
    required this.signedBy,
  }) : super(id: id);

  factory SignedBy.fromMap(Map<String, dynamic> map) {
    return SignedBy(
      id: map['ID'],
      signedBy: map['signedBy'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'signedBy': signedBy,
    };
  }
}