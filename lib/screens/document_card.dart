import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class DocumentCard extends StatelessWidget {
  final int documentId;
  final VoidCallback onFavoriteToggle;
  final DBHelper dbHelper;

  DocumentCard({
    required this.documentId,
    required this.onFavoriteToggle,
    required this.dbHelper,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbHelper.getFullDocumentById(documentId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return const ListTile(title: Text('Ошибка загрузки документа'));
        }

        final document = snapshot.data;

        return Card(
          child: ListTile(
            title: Text(document.title),
            subtitle: Text(document.text?.substring(0, 50) ?? 'Нет текста'),
            trailing: IconButton(
              icon: Icon(
                document.isPinned ? Icons.star : Icons.star_border,
                color: document.isPinned ? Colors.amber : null,
              ),
              onPressed: () async {
                await dbHelper.toggleDocumentPin(document.id, !document.isPinned);
                onFavoriteToggle();
              },
            ),
            onTap: () {
              // TODO: Реализовать переход к деталям документа
            },
          ),
        );
      },
    );
  }
}