import 'package:flutter/material.dart';
import '../resources/styles.dart';  // Импортируем файл стилей
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
        padding: defaultPadding,  // Используем стандартный отступ
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Вопрос
            Text(
              widget.test.question,
              style: questionTextStyle,
            ),
            SizedBox(height: 20),

            // Варианты ответов
            ...List.generate(widget.test.options.length, (index) {
              final isSelected = _selectedIndex == index;
              final isCorrect = widget.test.correctIndex == index;

              // Определяем цвета и стили
              Color backgroundColor = Colors.transparent;
              Color borderColor = Colors.grey;
              Icon answerIcon = defaultAnswerIcon;

              if (_isAnswered) {
                if (isCorrect) {
                  backgroundColor = correctAnswerColor.withAlpha(25);
                  borderColor = correctAnswerColor;
                  answerIcon = correctAnswerIcon;
                } else if (isSelected) {
                  backgroundColor = incorrectAnswerColor.withAlpha(25);
                  borderColor = incorrectAnswerColor;
                  answerIcon = incorrectAnswerIcon;
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
                    style: answerTextStyle.copyWith(
                      color: isSelected && !isCorrect && _isAnswered
                          ? incorrectAnswerColor
                          : Colors.black,
                    ),
                  ),
                  leading: _isAnswered ? answerIcon : defaultAnswerIcon,
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
                color: primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.article, color: primaryColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ссылка на закон: ${widget.test.lawReference}',
                      style: lawReferenceTextStyle,
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
                      padding: buttonPadding,  // Используем стандартный padding
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
