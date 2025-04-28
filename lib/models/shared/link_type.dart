class LinkType {
  final int id;
  final String typeLink;

  LinkType({
    required this.id,
    required this.typeLink,
  });

  factory LinkType.fromMap(Map<String, dynamic> map) {
    return LinkType(
      id: map['ID'],
      typeLink: map['typeLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'typeLink': typeLink,
    };
  }
}