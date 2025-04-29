import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ThemeManager {
  static const String _themeFileName = 'theme_prefs.txt';

  Future<ThemeMode> getThemeMode() async {
    try {
      final file = await _getThemeFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        return contents == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      debugPrint('Ошибка чтения темы: $e');
    }
    return ThemeMode.system;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final file = await _getThemeFile();
      await file.writeAsString(mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Ошибка сохранения темы: $e');
    }
  }

  Future<File> _getThemeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_themeFileName');
  }
}