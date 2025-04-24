import 'package:flutter/material.dart';
import '../resources/app_text_styles.dart';
//import '../resources/app_colors.dart';

class DocumentScreen extends StatelessWidget {
  final String title;
  final String date;
  final String docNumber;

  const DocumentScreen({
    super.key,
    this.title = 'Федеральный закон о чём-то важном',
    this.date = '2001-04-12',
    this.docNumber = '№123-ФЗ',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Документ', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: закладка
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(title, style: AppTextStyles.lawTitle(context)),
            const SizedBox(height: 6),
            Text('$date • $docNumber', style: AppTextStyles.lawReference(context)),
            const SizedBox(height: 16),
            Text(
              'Здесь будет текст документа (заглушка). ' * 20,
              style: AppTextStyles.lawExplanation(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onPressed: () {
                // TODO: отметить как прочитанный
              },
              child: const Text('Отметить как прочитанный'),
            )
          ],
        ),
      ),
    );
  }
}
