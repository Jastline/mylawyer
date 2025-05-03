import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/db_helper.dart';
import 'document_details_screen.dart';

class DocumentCard extends StatelessWidget {
  final RusLawDocument document;
  final VoidCallback onFavoriteToggle;
  final DBHelper dbHelper;

  const DocumentCard({
    required this.document,
    required this.onFavoriteToggle,
    required this.dbHelper,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(document.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.docNumber),
            if (document.docDate != null) Text(document.docDate),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            document.isPinned ? Icons.star : Icons.star_outline,
            color: document.isPinned ? Colors.amber : null,
          ),
          onPressed: () async {
            await dbHelper.togglePinStatus(document.id, !document.isPinned);
            onFavoriteToggle();
          },
        ),
        onTap: () => _showDocumentDetails(context),
      ),
    );
  }

  void _showDocumentDetails(BuildContext context) {
    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DocumentDetailsScreen(
              documentId: document.id,
              dbHelper: dbHelper,
            ),
      ),
    );
  }
}