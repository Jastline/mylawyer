import 'package:flutter/material.dart';

// Цвета
const Color primaryColor = Colors.blue;
const Color correctAnswerColor = Colors.green;
const Color incorrectAnswerColor = Colors.red;
const Color selectedAnswerColor = Colors.blueAccent;

// Иконки
const Icon correctAnswerIcon = Icon(Icons.check_circle, color: correctAnswerColor);
const Icon incorrectAnswerIcon = Icon(Icons.cancel, color: incorrectAnswerColor);
const Icon defaultAnswerIcon = Icon(Icons.circle_outlined, color: Colors.grey);

// Тексты
const TextStyle questionTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle answerTextStyle = TextStyle(fontSize: 16);
const TextStyle lawReferenceTextStyle = TextStyle(fontSize: 16, color: Colors.blue);

// Padding
const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
