import 'base_model.dart';

class Status extends BaseModel {
  final String status;

  Status({int? id, required this.status}) : super(id: id);

  factory Status.fromMap(Map<String, dynamic> map) => Status(
    id: map['ID'],
    status: map['status'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'status': status,
  };
}
