import 'base_model.dart';
import 'author.dart';
import 'document_type.dart';
import 'issued_by.dart';
import 'signed_by.dart';
import 'status.dart';
import 'keyword.dart';
import 'classifier.dart';

class RusLawDocument extends BaseModel {
  final String title;
  final String docDate;
  final String docNumber;
  final int internalNumber;
  final bool isWidelyUsed;
  final bool isPinned;
  final int? statusID;
  final int? authorID;
  final int? issuedByID;
  final int? signedByID;
  final int? docTypeID;

  // Связанные объекты (не сохраняются в БД напрямую)
  final DocumentType? docType;
  final Status? status;
  final Author? author;
  final IssuedBy? issuedBy;
  final SignedBy? signedBy;
  final String? text;
  final List<Keyword>? keywords;
  final List<Classifier>? classifiers;

  RusLawDocument({
    int? id,
    required this.title,
    required this.docDate,
    required this.docNumber,
    required this.internalNumber,
    required this.isWidelyUsed,
    this.isPinned = false,
    this.statusID,
    this.authorID,
    this.issuedByID,
    this.signedByID,
    this.docTypeID,
    this.docType,
    this.status,
    this.author,
    this.issuedBy,
    this.signedBy,
    this.text,
    this.keywords,
    this.classifiers,
  }) : super(id: id);

  factory RusLawDocument.fromMap(Map<String, dynamic> map) => RusLawDocument(
    id: map['ID'],
    title: map['title'],
    docDate: map['docDate'],
    docNumber: map['docNumber'],
    internalNumber: map['internalNumber'],
    isWidelyUsed: map['isWidelyUsed'] == 1,
    isPinned: map['isPinned'] == 1,
    statusID: map['statusID'],
    authorID: map['authorID'],
    issuedByID: map['issuedByID'],
    signedByID: map['signedByID'],
    docTypeID: map['docTypeID'],
  );

  // Метод copyWith для обновления полей
  RusLawDocument copyWith({
    int? id,
    String? title,
    String? docDate,
    String? docNumber,
    int? internalNumber,
    bool? isWidelyUsed,
    bool? isPinned,
    int? statusID,
    int? authorID,
    int? issuedByID,
    int? signedByID,
    int? docTypeID,
    DocumentType? docType,
    Status? status,
    Author? author,
    IssuedBy? issuedBy,
    SignedBy? signedBy,
    String? text,
    List<Keyword>? keywords,
    List<Classifier>? classifiers,
  }) {
    return RusLawDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      docDate: docDate ?? this.docDate,
      docNumber: docNumber ?? this.docNumber,
      internalNumber: internalNumber ?? this.internalNumber,
      isWidelyUsed: isWidelyUsed ?? this.isWidelyUsed,
      isPinned: isPinned ?? this.isPinned,
      statusID: statusID ?? this.statusID,
      authorID: authorID ?? this.authorID,
      issuedByID: issuedByID ?? this.issuedByID,
      signedByID: signedByID ?? this.signedByID,
      docTypeID: docTypeID ?? this.docTypeID,
      docType: docType ?? this.docType,
      status: status ?? this.status,
      author: author ?? this.author,
      issuedBy: issuedBy ?? this.issuedBy,
      signedBy: signedBy ?? this.signedBy,
      text: text ?? this.text,
      keywords: keywords ?? this.keywords,
      classifiers: classifiers ?? this.classifiers,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'ID': id,
    'title': title,
    'docDate': docDate,
    'docNumber': docNumber,
    'internalNumber': internalNumber,
    'isWidelyUsed': isWidelyUsed ? 1 : 0,
    'isPinned': isPinned ? 1 : 0,
    'statusID': statusID,
    'authorID': authorID,
    'issuedByID': issuedByID,
    'signedByID': signedByID,
    'docTypeID': docTypeID,
  };
}