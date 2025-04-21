import 'package:flutter/material.dart';
import '../models/test_model.dart';

class TestsScreen extends StatelessWidget {
  final List<TestModel> tests = [
    TestModel(
      question: 'Что такое правоспособность?',
      options: ['Способность иметь права', 'Способность их исполнять', 'Обязанность соблюдать закон'],
      correctIndex: 0,
      lawReference: 'ст. 17 ГК РФ',
    ),
    TestModel(
      question: 'Когда возникает дееспособность?',
      options: ['С рождения', 'С 14 лет', 'С 18 лет'],
      correctIndex: 2,
      lawReference: 'ст. 21 ГК РФ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Тесты')),
      body: ListView.builder(
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(test.question),
              subtitle: Text('Статья: ${test.lawReference}'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Вы выбрали: ${test.question}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
