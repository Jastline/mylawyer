import 'package:flutter/material.dart';
import '../models/test_model.dart';

class TestDetailScreen extends StatefulWidget {
  final TestModel test;

  const TestDetailScreen({Key? key, required this.test}) : super(key: key);

  @override
  _TestDetailScreenState createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вопрос')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Вопрос
            Text(
              widget.test.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Варианты ответов
            ...List.generate(widget.test.options.length, (index) {
              final isSelected = _selectedIndex == index;
              final isCorrect = widget.test.correctIndex == index;

              // Определяем цвета и стили
              Color backgroundColor = Colors.transparent;
              Color borderColor = Colors.grey;
              IconData? icon;
              Color iconColor = Colors.grey; // Инициализируем значением по умолчанию

              if (_isAnswered) {
                if (isCorrect) {
                  // Правильный ответ (подсвечиваем в любом случае)
                  backgroundColor = Colors.green.withAlpha(25); // Эквивалент withOpacity(0.1)
                  borderColor = Colors.green;
                  icon = Icons.check_circle;
                  iconColor = Colors.green;
                } else if (isSelected) {
                  // Выбран неправильный ответ
                  backgroundColor = Colors.red.withAlpha(25); // Эквивалент withOpacity(0.1)
                  borderColor = Colors.red;
                  icon = Icons.cancel;
                  iconColor = Colors.red;
                }
              }

              return Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    widget.test.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected && !isCorrect && _isAnswered
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                  leading: _isAnswered && icon != null
                      ? Icon(icon, color: iconColor)
                      : Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: _isAnswered
                      ? null
                      : () {
                    setState(() {
                      _selectedIndex = index;
                      _isAnswered = true;
                    });
                  },
                ),
              );
            }),

            // Статья на закон
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(25), // Эквивалент withOpacity(0.1)
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.article, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ссылка на закон: ${widget.test.lawReference}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Кнопка "Назад"
            if (_isAnswered)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.arrow_back),
                    label: Text('Назад к тестам'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}