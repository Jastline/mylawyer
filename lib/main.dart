import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Используем только provider

import 'models/base/db_helper.dart';
import 'widgets/theme_provider.dart';
import 'resources/app_theme.dart';
import 'screens/home_screen.dart';
import 'providers/app_providers.dart'; // <-- добавляем импорт!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных
  final dbHelper = DatabaseHelper();
  await dbHelper.database;

  // Создаём ThemeProvider и загружаем тему
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromDB();

  runApp(
    MyApp(themeProvider: themeProvider),
  );
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider<AppProviders>(
          create: (_) => AppProviders(), // <-- создаём AppProviders
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyLawyer',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
