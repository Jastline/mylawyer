import 'models.dart';

class RusLawDocument extends BaseModel {
  final String title;
  final String docDate;
  final String docNumber;
  final int internalNumber;
  final bool isPinned;
  final int docTypeID;
  final int statusID;
  final int authorID;
  final int issuedByID;
  final int signedByID;

  RusLawDocument({
    required int id,
    required this.title,
    required this.docDate,
    required this.docNumber,
    required this.internalNumber,
    required this.isPinned,
    required this.docTypeID,
    required this.statusID,
    required this.authorID,
    required this.issuedByID,
    required this.signedByID,
  }) : super(id: id);

  factory RusLawDocument.fromMap(Map<String, dynamic> map) {
    return RusLawDocument(
      id: map['ID'],
      title: map['title'],
      docDate: map['docDate'],
      docNumber: map['docNumber'],
      internalNumber: map['internalNumber'],
      isPinned: map['isPinned'] == 1,
      docTypeID: map['docTypeID'],
      statusID: map['statusID'],
      authorID: map['authorID'],
      issuedByID: map['issuedByID'],
      signedByID: map['signedByID'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'title': title,
      'docDate': docDate,
      'docNumber': docNumber,
      'internalNumber': internalNumber,
      'isPinned': isPinned ? 1 : 0,
      'docTypeID': docTypeID,
      'statusID': statusID,
      'authorID': authorID,
      'issuedByID': issuedByID,
      'signedByID': signedByID,
    };
  }

  RusLawDocument copyWith({
    String? title,
    String? docDate,
    String? docNumber,
    int? internalNumber,
    bool? isPinned,
    int? docTypeID,
    int? statusID,
    int? authorID,
    int? issuedByID,
    int? signedByID,
    String? text,
    List<Keyword>? keywords,
    String? docType,
    String? status,
    String? author,
    String? issuedBy,
    String? signedBy,
  }) {
    return RusLawDocument(
      id: id,
      title: title ?? this.title,
      docDate: docDate ?? this.docDate,
      docNumber: docNumber ?? this.docNumber,
      internalNumber: internalNumber ?? this.internalNumber,
      isPinned: isPinned ?? this.isPinned,
      docTypeID: docTypeID ?? this.docTypeID,
      statusID: statusID ?? this.statusID,
      authorID: authorID ?? this.authorID,
      issuedByID: issuedByID ?? this.issuedByID,
      signedByID: signedByID ?? this.signedByID,
    );
  }
}