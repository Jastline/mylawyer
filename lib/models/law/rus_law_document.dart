class RusLawDocument {
  int? id;
  String title;
  String docDate;
  String docNumber;
  int internalNumber;
  bool isWidelyUsed;

  RusLawDocument({
    this.id,
    required this.title,
    required this.docDate,
    required this.docNumber,
    required this.internalNumber,
    required this.isWidelyUsed,
  });

  // Преобразование данных в формат Map (для записи в БД)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'docDate': docDate,
      'docNumber': docNumber,
      'internalNumber': internalNumber,
      'isWidelyUsed': isWidelyUsed ? 1 : 0,
    };
  }

  // Преобразование Map в объект
  factory RusLawDocument.fromMap(Map<String, dynamic> map) {
    return RusLawDocument(
      id: map['id'],
      title: map['title'],
      docDate: map['docDate'],
      docNumber: map['docNumber'],
      internalNumber: map['internalNumber'],
      isWidelyUsed: map['isWidelyUsed'] == 1,
    );
  }
}
