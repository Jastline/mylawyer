class IssuedBy {
  final int id;
  final String issuedBy;

  IssuedBy({
    required this.id,
    required this.issuedBy,
  });

  factory IssuedBy.fromMap(Map<String, dynamic> map) {
    return IssuedBy(
      id: map['ID'],
      issuedBy: map['issuedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'issuedBy': issuedBy,
    };
  }
}