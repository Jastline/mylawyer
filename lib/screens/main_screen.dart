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
  // Контроллеры
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Состояние фильтрации
  int? _selectedDocTypeId;
  List<DocumentType> _docTypes = [];
  DateTime? _yearFrom;
  DateTime? _yearTo;

  // Состояние сортировки
  String _sortField = 'docDate';
  bool _sortAscending = false;

  // Состояние документов
  List<RusLawDocument> _documents = [];
  List<int> _filteredDocumentIds = [];
  int _currentBatchIndex = 0;
  final int _batchSize = 50;
  int _totalFound = 0;

  // Состояние загрузки
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isFiltering = false;
  int _filterProgress = 0;
  bool _showLoadingIndicator = false; // Новый флаг для индикатора загрузки

  // Навигация
  int _currentIndex = 0;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _initScrollListener();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged); // Добавляем слушатель для поиска
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Инициализация слушателей
  void _initScrollListener() {
    _scrollController.addListener(() {
      // Показать/скрыть кнопку "вверх"
      if (_scrollController.offset > 400 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 400 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }

      // Подгрузка при достижении конца списка
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {
        _fetchDocuments(reset: false);
      }
    });
  }

  // Основные методы загрузки данных
  Future<void> _loadInitialData() async {
    await _fetchDocTypes();
    await _fetchDocuments();
  }

  Future<void> _fetchDocTypes() async {
    try {
      final types = await widget.dbHelper.getDocumentTypes();
      if (mounted) setState(() => _docTypes = types);
    } catch (e) {
      debugPrint('Ошибка загрузки типов документов: $e');
      if (mounted) {
        setState(() => _docTypes = []);
        AppSnackBar.showError(context, 'Не удалось загрузить типы документов');
      }
    }
  }

  Future<void> _fetchDocuments({bool reset = true}) async {
    if (_isLoading || _isFiltering) return;

    setState(() {
      _isLoading = true;
      _showLoadingIndicator = true; // Показываем индикатор при начале загрузки
    });

    try {
      final searchQuery = _searchController.text.trim();

      if (reset) {
        _filteredDocumentIds = await widget.dbHelper.getAllFilteredDocumentIds(
          query: searchQuery.isEmpty ? null : searchQuery, // Если поиск пустой - null
          typeIds: _selectedDocTypeId != null ? [_selectedDocTypeId!] : null,
          dateFrom: _yearFrom,
          dateTo: _yearTo,
          sortField: _sortField,
          sortAscending: _sortAscending,
        );

        _currentBatchIndex = 0;
        _totalFound = _filteredDocumentIds.length;
      }

      if (_currentBatchIndex >= _filteredDocumentIds.length) {
        if (mounted) setState(() {
          _hasMore = false;
          _isLoading = false;
          _showLoadingIndicator = false; // Скрываем индикатор
        });
        return;
      }

      final batchIds = _filteredDocumentIds
          .skip(_currentBatchIndex)
          .take(_batchSize)
          .toList();

      final batchDocuments = await Future.wait(
          batchIds.map((id) => widget.dbHelper.getDocumentById(id))
      );

      if (!mounted) return;

      setState(() {
        if (reset) {
          _documents = batchDocuments.whereType<RusLawDocument>().toList();
        } else {
          _documents.addAll(batchDocuments.whereType<RusLawDocument>());
        }
        _currentBatchIndex += batchIds.length;
        _hasMore = _currentBatchIndex < _filteredDocumentIds.length;
        _isLoading = false;
        _showLoadingIndicator = false; // Скрываем индикатор
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
          _showLoadingIndicator = false; // Скрываем индикатор при ошибке
        });
        AppSnackBar.showError(context, 'Ошибка при загрузке документов');
      }
      debugPrint('Ошибка загрузки документов: $e');
    }
  }

  // Методы фильтрации
  void _onSearchChanged() {
    // Если строка поиска пустая - показываем все документы по текущим фильтрам
    if (_searchController.text.trim().isEmpty) {
      _fetchDocuments();
    } else {
      // Иначе выполняем поиск
      _fetchDocuments();
    }
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
      initialEntryMode: DatePickerEntryMode.input,
      helpText: isFrom ? 'Выберите начальный год' : 'Выберите конечный год',
      fieldLabelText: isFrom ? 'Начальный год' : 'Конечный год',
      fieldHintText: 'ГГГГ',
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _yearFrom = DateTime(picked.year, 1, 1);
          if (_yearTo != null && _yearTo!.isBefore(_yearFrom!)) {
            _yearTo = null;
          }
        } else {
          _yearTo = DateTime(picked.year, 12, 31);
          if (_yearFrom != null && _yearFrom!.isAfter(_yearTo!)) {
            _yearFrom = null;
          }
        }
      });
      _fetchDocuments();
    }
  }

  void _clearYearFilter() {
    if (mounted) setState(() {
      _yearFrom = null;
      _yearTo = null;
    });
    _fetchDocuments();
  }

  // Методы сортировки
  void _changeSort(String field) {
    if (mounted) setState(() {
      if (_sortField == field) {
        _sortAscending = !_sortAscending;
      } else {
        _sortField = field;
        _sortAscending = false;
      }
      _fetchDocuments();
    });
  }

  // Методы навигации
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Построение UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Поиск ($_totalFound)' : 'Избранное'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(!widget.isDarkTheme),
          ),
        ],
        bottom: _showLoadingIndicator
            ? PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: LinearProgressIndicator(
            minHeight: 2.0,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
            : null,
      ),
      body: _currentIndex == 0 ? _buildSearchScreen()
          : FavoritesScreen(dbHelper: widget.dbHelper),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        mini: true,
        onPressed: _scrollToTop,
        child: Icon(
          Icons.arrow_upward,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Закладки'),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Column(
      children: [
        _buildFilterProgressIndicator(),
        _buildSearchField(),
        _buildTypeFilter(),
        _buildYearFilter(),
        _buildSortOptions(),
        _buildDocumentsList(),
      ],
    );
  }

  Widget _buildFilterProgressIndicator() {
    if (!_isFiltering) return const SizedBox.shrink();

    return Column(
      children: [
        LinearProgressIndicator(
          value: _filterProgress / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'Фильтрация: $_filterProgress%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Поиск',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTypeChip(null, 'Все типы'),
          ..._docTypes.map((type) => _buildTypeChip(type.id, type.docType)),
        ],
      ),
    );
  }

  Widget _buildTypeChip(int? id, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedDocTypeId == id,
        onSelected: (selected) {
          if (selected) _onDocTypeSelected(id);
        },
      ),
    );
  }

  Widget _buildYearFilter() {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          _buildYearButton(true, textColor),
          const SizedBox(width: 8),
          _buildYearButton(false, textColor),
          if (_yearFrom != null || _yearTo != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearYearFilter,
              tooltip: 'Сбросить фильтр',
            ),
        ],
      ),
    );
  }

  Widget _buildYearButton(bool isFrom, Color? textColor) {
    return Expanded(
      child: OutlinedButton.icon(
        icon: Icon(Icons.calendar_today, size: 16, color: textColor),
        label: Text(
          isFrom
              ? _yearFrom != null
              ? 'С ${_yearFrom!.year}'
              : 'С года'
              : _yearTo != null
              ? 'По ${_yearTo!.year}'
              : 'По год',
          style: TextStyle(color: textColor),
        ),
        onPressed: () => _selectYear(context, isFrom),
        style: OutlinedButton.styleFrom(
          foregroundColor: (isFrom ? _yearFrom : _yearTo) != null
              ? Theme.of(context).primaryColor
              : textColor,
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Text('Сортировка:', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8),
          _buildSortButton('По названию', 'title'),
          const SizedBox(width: 8),
          _buildSortButton('По дате', 'docDate'),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, String field) {
    final isActive = _sortField == field;
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: isActive ? colorScheme.secondary : null,
      ),
      onPressed: () => _changeSort(field),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    if (_isLoading && _documents.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_documents.isEmpty && !_isLoading) {
      return const Expanded(child: Center(child: Text('Документы не найдены')));
    }

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _documents.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _documents.length) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
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