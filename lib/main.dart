import 'package:flutter/material.dart';
import 'test_model.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DBHelper();
  final existing = await db.getTests();
  if (existing.isEmpty) {
    await db.insertTest(TestModel(
      question: 'Что такое правоспособность?',
      options: ['Способность иметь права', 'Способность их исполнять', 'Обязанность соблюдать закон'],
      correctIndex: 0,
      lawReference: 'ст. 17 ГК РФ',
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
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TestsScreen(),
    );
  }
}

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});
  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  List<TestModel> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    final db = DBHelper();
    final data = await db.getTests();
    setState(() {
      _tests = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тесты')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tests.length,
        itemBuilder: (context, index) {
          final test = _tests[index];
          return ListTile(
            title: Text(test.question),
            subtitle: Text('Статья: ${test.lawReference}'),
          );
        },
      ),
    );
  }
}
