import 'package:flutter/material.dart';
import 'data/db_helper.dart';
import 'models/test_model.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DBHelper();
  final existingTests = await db.getAllTests();

  if (existingTests.isEmpty) {
    await db.insertTest(TestModel(
      question: 'Что такое правоспособность?',
      options: ['Способность иметь права', 'Способность их исполнять', 'Обязанность соблюдать закон'],
      correctIndex: 0,
      lawReference: 'ст. 17 ГК РФ',
    ));
    await db.insertTest(TestModel(
      question: 'Когда возникает дееспособность?',
      options: ['С рождения', 'С 14 лет', 'С 18 лет'],
      correctIndex: 2,
      lawReference: 'ст. 21 ГК РФ',
    ));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLawyer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const MainScreen(), // ← Запускаем главный экран с навигацией
    );
  }
}
