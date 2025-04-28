import 'package:flutter/material.dart';

class AppProviders with ChangeNotifier {
  int tabIndex = 0;

  // Фильтры для категории
  Set<String> filters = {'Основные'};

  // Фильтры для типа документа и важности
  String? selectedImportance;
  String? selectedDocType;

  // Фильтр по диапазону лет
  RangeValues yearRange = RangeValues(2000, DateTime.now().year.toDouble());

  // Статусы дисклеймера
  bool disclaimerShown = false;

  // Прогресс загрузки документов
  int downloadProgress = 0;
  int totalDocuments = 5;
  bool isDownloading = true;

  // Методы
  void setTabIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }

  void toggleFilter(String filter) {
    if (filters.contains(filter)) {
      filters.remove(filter);
    } else {
      filters.add(filter);
    }
    notifyListeners();
  }

  void setImportance(String? importance) {
    selectedImportance = importance;
    notifyListeners();
  }

  void setDocType(String? docType) {
    selectedDocType = docType;
    notifyListeners();
  }

  void setYearRange(RangeValues range) {
    yearRange = range;
    notifyListeners();
  }

  void setDisclaimerShown(bool value) {
    disclaimerShown = value;
    notifyListeners();
  }

  void updateDownloadProgress(int progress) {
    downloadProgress = progress;
    notifyListeners();
  }

  void setTotalDocuments(int total) {
    totalDocuments = total;
    notifyListeners();
  }

  void setIsDownloading(bool downloading) {
    isDownloading = downloading;
    notifyListeners();
  }
}
