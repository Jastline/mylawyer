// main.dart
import 'package:flutter/material.dart';

import 'services/db_helper.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных
  final dbHelper = DBHelper();
  await dbHelper.database;

  // Инициализация менеджера тем
  final themeManager = ThemeManager();
  final initialTheme = await themeManager.getThemeMode();

  runApp(
    MyApp(
      dbHelper: dbHelper,
      themeManager: themeManager,
      initialTheme: initialTheme,
    ),
  );
}

class MyApp extends StatefulWidget {
  final DBHelper dbHelper;
  final ThemeManager themeManager;
  final ThemeMode initialTheme;

  const MyApp({
    super.key,
    required this.dbHelper,
    required this.themeManager,
    required this.initialTheme,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialTheme;
  }

  void _toggleTheme(bool isDark) async {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await widget.themeManager.saveThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyLawyer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainScreen(
        dbHelper: widget.dbHelper,
        toggleTheme: _toggleTheme,
        isDarkTheme: _themeMode == ThemeMode.dark,
      ),
    );
  }
}