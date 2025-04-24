import 'package:flutter/material.dart';
import '../resources/app_theme.dart'; // не забудь про импорт

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;  // Принудительно задаём светлую тему

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    // Изменение темы
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeData get themeData {
    // Возвращаем тему в зависимости от выбранного режима
    return _themeMode == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
