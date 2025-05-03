import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../models/models.dart';
import '../widgets/app_snackbar.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final int documentId;
  final DBHelper dbHelper;

  const DocumentDetailsScreen({
    required this.documentId,
    required this.dbHelper,
    Key? key,
  }) : super(key: key);

  @override
  _DocumentDetailsScreenState createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  RusLawDocument? _document;
  String? _documentText;
  bool _isLoading = true;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final doc = await widget.dbHelper.getDocumentById(widget.documentId);
      final text = await widget.dbHelper.getDocumentText(widget.documentId);

      if (mounted) {
        setState(() {
          _document = doc;
          _documentText = text;
          _isPinned = doc?.isPinned ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Ошибка загрузки документа: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackBar.showError(context, 'Не удалось загрузить документ');
      }
    }
  }

  Future<void> _togglePin() async {
    if (_document == null) return;

    try {
      await widget.dbHelper.togglePinStatus(
        _document!.id,
        !_isPinned,
      );

      if (mounted) {
        setState(() => _isPinned = !_isPinned);
        AppSnackBar.showSuccess(
          context,
          _isPinned ? 'Документ добавлен в избранное' : 'Документ удалён из избранного',
        );
      }
    } catch (e) {
      debugPrint('Ошибка изменения статуса закрепления: $e');
      if (mounted) {
        AppSnackBar.showError(context, 'Ошибка при изменении статуса');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_document?.title ?? 'Документ'),
        actions: [
          IconButton(
            icon: Icon(_isPinned ? Icons.star : Icons.star_outline),
            onPressed: _togglePin,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _document == null
          ? const Center(child: Text('Документ не найден'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          _documentText ?? 'Нет содержимого',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}