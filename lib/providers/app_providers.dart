import 'package:flutter/material.dart';

class AppProviders with ChangeNotifier {
  int tabIndex = 0;
  Set<String> filters = {'Основные'};
  RangeValues yearRange = RangeValues(2000, DateTime.now().year.toDouble());
  bool disclaimerShown = false;
  int downloadProgress = 0;
  int totalDocuments = 5;
  bool isDownloading = true;

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
