import 'package:flutter/material.dart';
import 'data/db_helper.dart';
import 'models/test_model.dart';
import 'screens/test_detail_screen.dart';


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
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLawyer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: TestsScreen(),
    );
  }
}

class TestsScreen extends StatefulWidget {
  @override
  _TestsScreenState createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<TestModel> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    print('Загрузка тестов...');
    final tests = await _dbHelper.getAllTests();
    print('Найдено тестов: ${tests.length}');
    for (var t in tests) {
      print('Тест: ${t.question}');
    }

    setState(() {
      _tests = tests;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Тесты')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tests.length,
        itemBuilder: (context, index) {
          final test = _tests[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(test.question),
              subtitle: Text('Статья: ${test.lawReference}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestDetailScreen(test: test),
                  ),
                );
              },
            )
          );
        },
      ),
    );
  }
}
