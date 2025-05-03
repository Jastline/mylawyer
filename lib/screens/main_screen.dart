// main_screen.dart
import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'document_card.dart';
import '../models/models.dart';
import 'favorites_screen.dart';
import '../widgets/app_snackbar.dart';

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
  final ScrollController _scrollController = ScrollController();
  int? _selectedDocTypeId;
  List<DocumentType> _docTypes = [];
  List<RusLawDocument> _documents = [];
  List<RusLawDocument> _displayedDocuments = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentIndex = 0;
  int _offset = 0;
  final int _limit = 50;
  int _totalFound = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await _fetchDocTypes();
  }

  Future<void> _fetchDocTypes() async {
    try {
      final types = await widget.dbHelper.getDocumentTypes();
      setState(() => _docTypes = types);
    } catch (e) {
      debugPrint('Ошибка загрузки типов документов: $e');
      setState(() => _docTypes = []);
      AppSnackBar.showError(context, 'Не удалось загрузить типы документов');
    }
  }

  Future<void> _fetchDocuments({bool reset = true}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (reset) {
        _offset = 0;
        _hasMore = true;
        _documents.clear();
        _displayedDocuments.clear();
      }
    });

    try {
      final result = await widget.dbHelper.searchDocuments(
        query: _searchController.text,
        typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
        limit: _limit,
        offset: _offset,
      );

      if (!mounted) return;

      int totalCount = _totalFound;
      if (reset) {
        totalCount = await widget.dbHelper.getDocumentsCount(
          query: _searchController.text,
          typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
        );
      }

      setState(() {
        _isLoading = false;
        _documents.addAll(result);
        _displayedDocuments = List.from(_documents);
        _offset += _limit;
        _hasMore = result.length == _limit;
        _totalFound = totalCount;

        if (reset && (_searchController.text.isNotEmpty || _selectedDocTypeId != null)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              AppSnackBar.showQuickInfo(
                context,
                'Найдено документов: $_totalFound. Показано: ${_displayedDocuments.length}',
              );
            }
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackBar.showError(context, 'Ошибка при загрузке документов');
      }
      debugPrint('Ошибка загрузки документов: $e');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading &&
        mounted) {
      _fetchDocuments(reset: false);
    }
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
        title: Text(_currentIndex == 0 ? 'Поиск' : 'Избранное'),
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
      body: _currentIndex == 0 ? _buildSearchScreen() : FavoritesScreen(dbHelper: widget.dbHelper),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Закладки',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Column(
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
    if (_isLoading && _displayedDocuments.isEmpty) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_displayedDocuments.isEmpty && !_isLoading) {
      return const Expanded(
        child: Center(child: Text('Документы не найдены')),
      );
    }

    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              _scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent &&
              _hasMore &&
              !_isLoading) {
            _fetchDocuments(reset: false);
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _displayedDocuments.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= _displayedDocuments.length) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }

            final doc = _displayedDocuments[index];
            return DocumentCard(
              document: doc,
              onFavoriteToggle: () => _fetchDocuments(),
              dbHelper: widget.dbHelper,
            );
          },
        ),
      ),
    );
  }
}