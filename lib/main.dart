import 'package:flutter/material.dart';
import 'screens/tests_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyLawyer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: TestsScreen(),
    );
  }
}
