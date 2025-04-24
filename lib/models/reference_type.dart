class ReferenceType {
  final int id;
  final String referenceType;

  ReferenceType({
    required this.id,
    required this.referenceType,
  });

  factory ReferenceType.fromMap(Map<String, dynamic> map) {
    return ReferenceType(
      id: map['ID'],
      referenceType: map['referenceType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'referenceType': referenceType,
    };
  }
}
