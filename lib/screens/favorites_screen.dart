import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'document_card.dart';

class FavoritesScreen extends StatefulWidget {
  final DBHelper dbHelper;

  const FavoritesScreen({required this.dbHelper, Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Map<String, List<int>> _favoritesByType = {}; // Храним только ID документов
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() => _isLoading = true);

    // Получаем ID закрепленных документов
    final pinnedDocs = await widget.dbHelper.getPinnedDocuments();

    // Группируем по типам документов
    final Map<String, List<int>> grouped = {};

    for (final docId in pinnedDocs.map((d) => d.id!)) {
      final doc = await widget.dbHelper.getFullDocumentById(docId);
      if (doc != null) {
        final docType = await widget.dbHelper.getDocumentTypeById(doc.docTypeID!);
        final typeName = docType?.docType ?? 'Без типа';
        grouped.putIfAbsent(typeName, () => []).add(docId);
      }
    }

    setState(() {
      _favoritesByType = grouped;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_favoritesByType.isEmpty) {
      return const Center(child: Text('Нет избранных документов'));
    }

    return ListView(
      children: _favoritesByType.entries.map((entry) {
        return ExpansionTile(
          title: Text(entry.key),
          children: entry.value.map((docId) {
            return FutureBuilder(
              future: widget.dbHelper.getFullDocumentById(docId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const ListTile(title: Text('Загрузка...'));
                }

                final doc = snapshot.data!;
                return DocumentCard(
                  documentId: doc.id!,
                  onFavoriteToggle: _fetchFavorites,
                  dbHelper: widget.dbHelper,
                );
              },
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}