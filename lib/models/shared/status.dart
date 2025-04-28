class Status {
  final int id;
  final String status;

  Status({
    required this.id,
    required this.status,
  });

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['ID'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'status': status,
    };
  }
}