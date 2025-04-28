import 'package:flutter/material.dart';
import '../providers/app_providers.dart'; // Импортируй корректно
import '../models/models.dart'; // Импортируй свои модели
import 'package:provider/provider.dart';

class DocumentSearchService {
  final BuildContext context;

  DocumentSearchService(this.context);

  /// Получение всех документов (заглушка)
  List<RusLawDocument> _getMockDocuments() {
    // Здесь твоя логика получения документов
    return [];
  }

  /// Поиск по тексту документа (если есть отдельно)
  List<RusLawDocument> _searchText(String query) {
    // Здесь твоя логика поиска по тексту
    return [];
  }

  /// Парсинг строки даты в DateTime
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
    } catch (e) {
      // Логировать можно здесь при необходимости
    }
    return null;
  }

  /// Основной метод поиска
  List<RusLawDocument> searchDocuments(String query) {
    if (query.isEmpty) {
      return _getMockDocuments();
    }

    final lowerCaseQuery = query.toLowerCase();
    final yearRange = context.read<AppProviders>().yearRange;
    final documents = _getMockDocuments();

    // Результаты поиска по атрибутам документа
    final results = documents.where((doc) {
      final titleMatch = doc.title.toLowerCase().contains(lowerCaseQuery);
      final docNumberMatch = doc.docNumber.toLowerCase().contains(lowerCaseQuery);
      final internalNumberMatch = doc.internalNumber.toString().contains(query);
      final isWidelyUsedMatch = doc.isWidelyUsed.toString().contains(query);

      final docDate = _parseDocDate(doc.docDate);
      final yearMatch = docDate != null &&
          docDate.year >= yearRange.start.toInt() &&
          docDate.year <= yearRange.end.toInt();

      return (titleMatch || docNumberMatch || internalNumberMatch || isWidelyUsedMatch) && yearMatch;
    }).toList();

    // Результаты поиска по тексту
    final resultsByText = _searchText(query);

    // Объединение результатов без дубликатов
    final combinedResults = {...results, ...resultsByText}.toList();

    return combinedResults;
  }
}
