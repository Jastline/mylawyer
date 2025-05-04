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
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentIndex = 0;
  int _offset = 0;
  final int _limit = 50;
  int _totalFound = 0;

  // Фильтрация по годам
  DateTime? _yearFrom;
  DateTime? _yearTo;

  // Сортировка
  String _sortField = 'docDate';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
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
      }
    });

    try {
      final result = await widget.dbHelper.searchDocuments(
        query: _searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null,
        typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
        dateFrom: _yearFrom,
        dateTo: _yearTo,
        sortField: _sortField,
        sortAscending: _sortAscending,
        limit: _limit,
        offset: reset ? 0 : _offset,
      );

      if (!mounted) return;

      final totalCount = await widget.dbHelper.getDocumentsCount(
        query: _searchController.text.trim().isNotEmpty
            ? _searchController.text.trim()
            : null,
        typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
        dateFrom: _yearFrom,
        dateTo: _yearTo,
      );

      setState(() {
        _isLoading = false;
        if (reset) {
          _documents = result;
          _totalFound = totalCount;
        } else {
          _documents.addAll(result);
        }
        _offset = _documents.length;
        _hasMore = result.length == _limit;
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
        !_isLoading) {
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

  Future<void> _selectYear(BuildContext context, bool isFrom) async {
    final initialDate = isFrom ? _yearFrom : _yearTo;
    final firstDate = DateTime(1900);
    final lastDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _yearFrom = DateTime(picked.year, 1, 1);
        } else {
          _yearTo = DateTime(picked.year, 12, 31);
        }
      });
      _fetchDocuments();
    }
  }

  void _clearYearFilter() {
    setState(() {
      _yearFrom = null;
      _yearTo = null;
    });
    _fetchDocuments();
  }

  void _changeSort(String field) {
    setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = false;
      }
      _fetchDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Поиск ($_totalFound)' : 'Избранное'),
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
        _buildYearFilter(),
        _buildSortOptions(),
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
            label: const Text('Все типы'),
            selected: _selectedDocTypeId == null,
            onSelected: (bool selected) {
              if (selected) _onDocTypeSelected(null);
            },
          ),
          ..._docTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(type.docType),
                selected: _selectedDocTypeId == type.id,
                onSelected: (bool selected) {
                  if (selected) _onDocTypeSelected(type.id);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildYearFilter() {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.calendar_today, size: 16, color: textColor),
              label: Text(
                _yearFrom != null ? 'С ${_yearFrom!.year}' : 'С года',
                style: TextStyle(color: textColor),
              ),
              onPressed: () => _selectYear(context, true),
              style: OutlinedButton.styleFrom(
                foregroundColor: _yearFrom != null
                    ? Theme.of(context).primaryColor
                    : textColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.calendar_today, size: 16, color: textColor),
              label: Text(
                _yearTo != null ? 'По ${_yearTo!.year}' : 'По год',
                style: TextStyle(color: textColor),
              ),
              onPressed: () => _selectYear(context, false),
              style: OutlinedButton.styleFrom(
                foregroundColor: _yearTo != null
                    ? Theme.of(context).primaryColor
                    : textColor,
              ),
            ),
          ),
          if (_yearFrom != null || _yearTo != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearYearFilter,
              tooltip: 'Сбросить фильтр по годам',
              color: textColor,
            ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Text('Сортировка:', style: theme.textTheme.bodyMedium),
          const SizedBox(width: 8),
          _buildSortChip(
            label: 'По названию',
            field: 'title',
            currentField: _sortField,
            ascending: _sortAscending,
          ),
          const SizedBox(width: 8),
          _buildSortChip(
            label: 'По дате',
            field: 'docDate',
            currentField: _sortField,
            ascending: _sortAscending,
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip({
    required String label,
    required String field,
    required String currentField,
    required bool ascending,
  }) {
    final isSelected = currentField == field;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              ),
            ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) _changeSort(field);
      },
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDocumentsList() {
    if (_isLoading && _documents.isEmpty) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_documents.isEmpty && !_isLoading) {
      return const Expanded(
        child: Center(child: Text('Документы не найдены')),
      );
    }

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _documents.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _documents.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final doc = _documents[index];
          return DocumentCard(
            document: doc,
            onFavoriteToggle: () => _fetchDocuments(),
            dbHelper: widget.dbHelper,
          );
        },
      ),
    );
  }
}