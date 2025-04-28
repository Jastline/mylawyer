import 'package:flutter/material.dart';
import '../models/user/user_profile.dart';
import '../models/base/db_helper.dart';
import '../resources/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeFromDB() async {
    final db = await _dbHelper.database;
    final profile = await db.query('user_profile', limit: 1);

    if (profile.isNotEmpty) {
      final user = UserProfile.fromMap(profile.first);
      _themeMode = user.lightTheme ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final db = await _dbHelper.database;
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    await db.transaction((txn) async {
      await txn.update(
        'user_profile',
        {'lightTheme': _themeMode == ThemeMode.light ? 1 : 0},
        where: 'ID = 1',
      );
    });

    notifyListeners();
  }

  ThemeData get themeData => _themeMode == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
}