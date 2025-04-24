import 'package:flutter/material.dart';
import '../services/user_db_service.dart';
import '../resources/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeFromDB() async {
    final isLight = await UserDatabaseService().getUserTheme(); // true or false
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = _themeMode == ThemeMode.dark;
    _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await UserDatabaseService().updateUserTheme(!_themeMode.isDarkMode); // light == const
  }

  ThemeData get themeData => _themeMode == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
}

extension on ThemeMode {
  bool get isDarkMode => this == ThemeMode.dark;
}
