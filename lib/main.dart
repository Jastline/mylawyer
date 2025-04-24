import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db_helper.dart';
import 'models/test.dart';
import 'resources/app_theme.dart';
import 'screens/main_screen.dart';
import 'services/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Инициализация базы данных (из assets)
    final db = DBHelper();
    await db.initializeDatabase();

    // Инициализация сервиса профиля
    final profileService = ProfileService(db);
    await profileService.loadProfile();

    // Инициализация тестовых данных, если их нет
    await _initializeTestData(db);

    runApp(
      ChangeNotifierProvider(
        create: (_) => profileService,
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Ошибка инициализации приложения: $e');
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Произошла ошибка при запуске приложения'),
          ),
        ),
      ),
    );
  }
}

Future<void> _initializeTestData(DBHelper db) async {
  try {
    final existingTests = await db.getAllTests();
    if (existingTests.isNotEmpty) return;

    const testData = [
      {
        'question': 'Что такое правоспособность?',
        'options': [
          'Способность иметь права',
          'Способность их исполнять',
          'Обязанность соблюдать закон'
        ],
        'correctIndex': 0,
        'articleReference': 'ст. 17 ГК РФ',
        'legalArea': 'Гражданское право',
        'difficulty': 'Легкая',
        'explanation': 'Правоспособность – это способность иметь гражданские права.',
        'isCompleted': false,
        'completedAt': null,
        'timeLimitSeconds': 60,
      },
    ];

    for (final test in testData) {
      await db.insertTest(TestModel(
        question: test['question'] as String,
        options: (test['options'] as List).cast<String>(),
        correctIndex: test['correctIndex'] as int,
        articleReference: test['articleReference'] as String,
        legalArea: test['legalArea'] as String,
        difficulty: test['difficulty'] as String,
        explanation: test['explanation'] as String,
        isCompleted: test['isCompleted'] as bool,
        completedAt: test['completedAt'] != null
            ? DateTime.parse(test['completedAt'] as String)
            : null,
        timeLimitSeconds: test['timeLimitSeconds'] as int,
      ));
    }
  } catch (e) {
    debugPrint('Ошибка инициализации тестов: $e');
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
