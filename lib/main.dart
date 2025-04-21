import 'package:flutter/material.dart';
import 'data/db_helper.dart';
import 'models/test_model.dart';
import 'models/law_article.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DBHelper();

  // Инициализация тестовых данных
  await _initializeTestData(db);
  await _initializeLawData(db);

  runApp(const MyApp());
}

Future<void> _initializeTestData(DBHelper db) async {
  final existingTests = await db.getAllTests();
  if (existingTests.isEmpty) {
    await db.insertTest(TestModel(
      question: 'Что такое правоспособность?',
      options: [
        'Способность иметь права',
        'Способность их исполнять',
        'Обязанность соблюдать закон'
      ],
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
}

Future<void> _initializeLawData(DBHelper db) async {
  final existingArticles = await db.getAllLaws();
  if (existingArticles.isEmpty) {
    final laws = [
      LawArticle(
        id: 0,
        code: 'ГК РФ',
        chapter: 'Глава 3. Гражданская правоспособность',
        articleNumber: 'ст. 17',
        title: 'Гражданская правоспособность',
        content: 'Правоспособность гражданина возникает в момент его рождения и прекращается смертью.',
      ),
      LawArticle(
        id: 1,
        code: 'ГК РФ',
        chapter: 'Глава 3. Гражданская правоспособность',
        articleNumber: 'ст. 18',
        title: 'Имущественные права',
        content: 'Гражданин может иметь имущество на праве собственности, наследовать и завещать его...',
      ),
      LawArticle(
        id: 2,
        code: 'ГК РФ',
        chapter: 'Глава 4. Гражданская дееспособность',
        articleNumber: 'ст. 21',
        title: 'Полная дееспособность',
        content: 'Полная дееспособность наступает по достижении 18 лет.',
      ),
    ];

    for (final law in laws) {
      await db.insertLaw(law);
    }
  }
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
      home: const MainScreen(),
    );
  }
}