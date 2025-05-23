import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'document_card.dart';
import '../models/models.dart';
import '../widgets/app_snackbar.dart';

class FavoritesScreen extends StatefulWidget {
  final DBHelper dbHelper;

  const FavoritesScreen({required this.dbHelper, Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<RusLawDocument> _pinnedDocuments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPinnedDocuments();
  }

  Future<void> _loadPinnedDocuments() async {
    setState(() => _isLoading = true);

    try {
      final pinnedDocs = await widget.dbHelper.getPinnedDocuments();
      setState(() {
        _pinnedDocuments = pinnedDocs;
        _isLoading = false;
      });

      // Просто количество без дополнительного текста
      AppSnackBar.showQuickInfo(
        context,
        'В закладках документов: ${pinnedDocs.length}',
      );
    } catch (e) {
      debugPrint('Ошибка загрузки избранных документов: $e');
      setState(() => _isLoading = false);
      AppSnackBar.showError(context, 'Не удалось загрузить избранные документы');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pinnedDocuments.isEmpty
          ? const Center(child: Text('Нет избранных документов'))
          : ListView.builder(
        itemCount: _pinnedDocuments.length,
        itemBuilder: (context, index) {
          return DocumentCard(
            document: _pinnedDocuments[index],
            onFavoriteToggle: _loadPinnedDocuments,
            dbHelper: widget.dbHelper,
          );
        },
      ),
    );
  }
}