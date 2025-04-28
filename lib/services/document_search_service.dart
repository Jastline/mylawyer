import 'package:flutter/material.dart';
import '../models/models.dart';

class DocumentSearchService {
  final BuildContext context;

  DocumentSearchService(this.context);

  // TODO: Заменить на реальную загрузку справочника типов документов из базы данных
  Future<List<DocumentType>> getDocumentTypes() async {
    return [];
  }

  // Поиск документов
  List<RusLawDocument> searchDocuments({
    required String searchQuery,
    String? importance, // 'true' или 'false'
    String? docType,    // название типа документа
    RangeValues? yearRange,
  }) {
    final documents = _getMockDocuments(); // TODO: заменить на реальную загрузку из БД

    if (searchQuery.isEmpty && importance == null && docType == null && yearRange == null) {
      return documents;
    }

    final lowerCaseQuery = searchQuery.toLowerCase();

    return documents.where((doc) {
      final titleMatch = doc.title.toLowerCase().contains(lowerCaseQuery);
      final docNumberMatch = doc.docNumber.toLowerCase().contains(lowerCaseQuery);
      final internalNumberMatch = doc.internalNumber.toString().contains(searchQuery);
      final widelyUsedMatch = doc.isWidelyUsed.toString().contains(searchQuery);

      final docDate = _parseDocDate(doc.docDate);
      final yearMatch = docDate == null || (
          yearRange != null &&
              docDate.year >= yearRange.start.toInt() &&
              docDate.year <= yearRange.end.toInt()
      );

      final importanceMatch = importance == null || doc.isWidelyUsed.toString() == importance;

      // TODO: Получить имя типа документа из справочника на основе docTypeID
      final documentTypeName = _getDocTypeNameById(doc.docTypeID);
      final docTypeMatch = docType == null || documentTypeName == docType;

      return (titleMatch || docNumberMatch || internalNumberMatch || widelyUsedMatch) &&
          yearMatch &&
          importanceMatch &&
          docTypeMatch;
    }).toList();
  }

  Future<List<String>> getAvailableDocTypes() async {
    final types = await getDocumentTypes();
    return types.map((dt) => dt.docType).toList();
  }

  Future<RangeValues> getYearRange() async {
    // TODO: Получать диапазон лет из базы
    return const RangeValues(1900, 2023);
  }

  String? _getDocTypeNameById(int id) {
    // TODO: Вместо моков — искать тип документа по ID через справочник из БД
    return null;
  }

  List<RusLawDocument> _getMockDocuments() {
    // TODO: заменить на реальную базу данных
    return [];
  }

  DateTime? _parseDocDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final parts = dateString.split('.');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {
      // Ошибка парсинга даты
    }
    return null;
  }
}
