import 'package:flutter/material.dart';
import '../models/models.dart';
import '../resources/resources.dart';

class DocumentScreen extends StatelessWidget {
  final RusLawDocument document;

  // Принимаем документ через параметр конструктора
  const DocumentScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Документ', style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Реализовать функционал закладки
              _toggleBookmark(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Заголовок документа
            Text(document.title, style: AppTextStyles.lawTitle(context)),
            const SizedBox(height: 6),
            // Дата и номер документа
            Text(
              '${document.docDate} • ${document.docNumber}',
              style: AppTextStyles.lawReference(context),
            ),
            const SizedBox(height: 16),
            // Текст документа (заменить на реальный текст документа)
            Text(
              'Здесь будет текст документа (заглушка). ' * 20,
              style: AppTextStyles.lawExplanation(context),
            ),
            const SizedBox(height: 20),
            // Кнопка для отметки как прочитанный
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onPressed: () {
                // TODO: Реализовать логику для отметки документа как прочитанного
                _markAsRead(context);
              },
              child: const Text('Отметить как прочитанный'),
            )
          ],
        ),
      ),
    );
  }

  void _toggleBookmark(BuildContext context) {
    // Логика для добавления или удаления закладки
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Документ добавлен в закладки')),
    );
  }

  void _markAsRead(BuildContext context) {
    // Логика для отметки документа как прочитанного
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Документ отмечен как прочитанный')),
    );
  }
}
