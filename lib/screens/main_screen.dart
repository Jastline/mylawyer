import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'document_card.dart';
import '../models/models.dart';

class MainScreen extends StatefulWidget {
  final DBHelper dbHelper;
  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const MainScreen({
    required this.dbHelper,
    required this.toggleTheme,
    required this.isDarkTheme,
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedDocTypeId;
  List<DocumentType> _docTypes = [];
  List<RusLawDocument> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _fetchDocTypes();
    await _fetchDocuments();
  }

  Future<void> _fetchDocTypes() async {
    try {
      final types = await widget.dbHelper.getDocumentTypes();
      setState(() => _docTypes = types);
    } catch (e) {
      // Обработка ошибки
      debugPrint('Ошибка загрузки типов документов: $e');
      setState(() => _docTypes = []);
    }
  }

  Future<void> _fetchDocuments() async {
    setState(() => _isLoading = true);

    final docs = await widget.dbHelper.searchDocuments(
      query: _searchController.text,
      typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
    );

    setState(() {
      _documents = docs;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _fetchDocuments();
  }

  void _onDocTypeSelected(int? typeId) {
    setState(() => _selectedDocTypeId = typeId);
    _fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLawyer'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () => widget.toggleTheme(!widget.isDarkTheme),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: const InputDecoration(
                labelText: 'Поиск',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          _buildTypeFilter(),
          _buildDocumentsList(),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Все'),
            selected: _selectedDocTypeId == null,
            onSelected: (_) => _onDocTypeSelected(null),
          ),
          ..._docTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(type.docType),
                selected: _selectedDocTypeId == type.id,
                onSelected: (_) => _onDocTypeSelected(type.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    if (_isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_documents.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Документы не найдены')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final doc = _documents[index];
          return DocumentCard(
            document: doc,
            onFavoriteToggle: _fetchDocuments,
            dbHelper: widget.dbHelper,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}