class SignedBy {
  final int id;
  final String signedBy;

  SignedBy({
    required this.id,
    required this.signedBy,
  });

  factory SignedBy.fromMap(Map<String, dynamic> map) {
    return SignedBy(
      id: map['ID'],
      signedBy: map['signedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'signedBy': signedBy,
    };
  }
}
