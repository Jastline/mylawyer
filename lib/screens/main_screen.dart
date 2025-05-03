import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'document_card.dart';

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
  String _searchKeyword = '';
  String? _selectedDocType;
  List<String> _docTypes = [];
  List<int> _documentIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _fetchDocTypes();
    await _fetchDocuments();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchDocTypes() async {
    final types = await widget.dbHelper.getDocumentTypes();
    _docTypes = types.map((type) => type.docType).toList();
  }

  Future<void> _fetchDocuments() async {
    setState(() => _isLoading = true);

    final docs = await widget.dbHelper.searchDocuments(
      title: _searchKeyword.isNotEmpty ? _searchKeyword : null,
      docTypeId: _selectedDocType != null
          ? _docTypes.indexOf(_selectedDocType!) + 1
          : null,
    );

    setState(() {
      _documentIds = docs.map((doc) => doc.id!).toList();
      _isLoading = false;
    });
  }

  void _onSearchChanged(String keyword) {
    _searchKeyword = keyword;
    _fetchDocuments();
  }

  void _onDocTypeSelected(String? docType) {
    _selectedDocType = docType;
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
            onPressed: () {
              widget.toggleTheme(!widget.isDarkTheme);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Поиск',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Все'),
                  selected: _selectedDocType == null,
                  onSelected: (_) => _onDocTypeSelected(null),
                ),
                ..._docTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: _selectedDocType == type,
                      onSelected: (_) => _onDocTypeSelected(type),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: _documentIds.isEmpty
                ? const Center(child: Text('Документы не найдены'))
                : ListView.builder(
              itemCount: _documentIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: widget.dbHelper.getFullDocumentById(
                      _documentIds[index]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(
                          title: Text('Загрузка...'));
                    }
                    return DocumentCard(
                      documentId: _documentIds[index],
                      onFavoriteToggle: _fetchDocuments,
                      dbHelper: widget.dbHelper,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}