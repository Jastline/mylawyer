import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/user_db_service.dart';
import 'widgets/theme_provider.dart';
import 'resources/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных
  await UserDatabaseService.instance.init();

  // Создаём ThemeProvider и загружаем тему из БД
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromDB();

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeProvider,
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
