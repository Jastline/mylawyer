import 'package:flutter/material.dart';

class DocumentSearchScreen extends StatelessWidget {
  const DocumentSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Экран поиска фильтров и документов', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
