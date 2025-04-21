import 'package:flutter/material.dart';
import '../models/test_model.dart';

class TestDetailScreen extends StatelessWidget {
  final TestModel test;

  const TestDetailScreen({Key? key, required this.test}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вопрос')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(test.options.length, (index) {
              return ListTile(
                title: Text(test.options[index]),
                leading: Icon(Icons.circle_outlined),
              );
            }),
            SizedBox(height: 30),
            Text('Ссылка на закон: ${test.lawReference}'),
          ],
        ),
      ),
    );
  }
}
