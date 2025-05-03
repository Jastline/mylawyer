import 'models.dart';

class Status extends BaseModel {
  final String status;

  Status({
    required int id,
    required this.status,
  }) : super(id: id);

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['ID'],
      status: map['status'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'status': status,
    };
  }
}