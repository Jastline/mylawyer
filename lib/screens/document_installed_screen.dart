import 'package:flutter/material.dart';

class DocumentInstalledScreen extends StatelessWidget {
  const DocumentInstalledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Экран установленных документов', style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
