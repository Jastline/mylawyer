import 'package:flutter/material.dart';
import '../../services/yandex_disk_service.dart';
import '../../widgets/document_search_screen/document_type_filter_widget.dart';
import '../../widgets/document_search_screen/importance_filter_widget.dart';
import '../../widgets/document_search_screen/year_range_filter_widget.dart';
import 'document_download_screen.dart';

class DocumentSearchScreen extends StatefulWidget {
  const DocumentSearchScreen({super.key});

  @override
  _DocumentSearchScreenState createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  final YandexDiskService _yandexService = YandexDiskService();

  String _selectedImportance = 'Основной';
  List<String> _selectedDocTypes = [];
  List<String> _availableDocTypes = [];
  RangeValues _selectedYearRange = const RangeValues(1950, 2023);
  int _minYear = 1950;
  int _maxYear = 2023;
  bool _isLoading = false;
  bool _showResults = false;
  List<String> _foundDatabases = [];

  @override
  void initState() {
    super.initState();
    _loadDocumentTypes();
  }

  Future<void> _loadDocumentTypes() async {
    setState(() {
      _isLoading = true;
      _selectedDocTypes = [];
      _showResults = false;
    });

    try {
      _availableDocTypes = await _yandexService.fetchDocumentTypes(_selectedImportance);
      _updateYearRange();
    } catch (e) {
      _showError('Ошибка загрузки типов документов: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateYearRange() async {
    if (_selectedDocTypes.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final allYears = <int>[];

      for (final type in _selectedDocTypes) {
        final years = await _yandexService.fetchAvailableYears(_selectedImportance, type);
        if (years.isNotEmpty) {
          allYears.addAll([years[0], years[1]]);
        }
      }

      if (allYears.isNotEmpty) {
        setState(() {
          _minYear = allYears.reduce((a, b) => a < b ? a : b);
          _maxYear = allYears.reduce((a, b) => a > b ? a : b);
          _selectedYearRange = RangeValues(_minYear.toDouble(), _maxYear.toDouble());
        });
      }
    } catch (e) {
      _showError('Ошибка загрузки диапазона годов: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _findDatabases() {
    setState(() {
      _isLoading = true;
      _showResults = false;
    });

    // Здесь должна быть реальная логика поиска БД
    // Это временная заглушка для демонстрации
    Future.delayed(const Duration(seconds: 1), () {
      final databases = <String>[];
      for (final type in _selectedDocTypes) {
        for (int year = _selectedYearRange.start.toInt();
        year <= _selectedYearRange.end.toInt();
        year++) {
          databases.add('$_selectedImportance/$type/$year.db');
        }
      }

      setState(() {
        _foundDatabases = databases;
        _showResults = true;
        _isLoading = false;
      });
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск документов'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Шаг 1: Выбор важности
            const Text('1. Выберите важность:', style: TextStyle(fontWeight: FontWeight.bold)),
            ImportanceFilterWidget(
              selectedImportance: _selectedImportance,
              onImportanceChanged: (value) {
                setState(() => _selectedImportance = value);
                _loadDocumentTypes();
              },
            ),
            const SizedBox(height: 24),

            // Шаг 2: Выбор типов документов
            const Text('2. Выберите типы документов:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (_availableDocTypes.isNotEmpty)
              DocumentTypeFilterWidget(
                selectedDocTypes: _selectedDocTypes,
                docTypes: _availableDocTypes,
                onDocTypesChanged: (types) {
                  setState(() => _selectedDocTypes = types);
                  _updateYearRange();
                },
              ),
            const SizedBox(height: 24),

            // Шаг 3: Выбор диапазона годов
            if (_selectedDocTypes.isNotEmpty) ...[
              const Text('3. Выберите диапазон годов:', style: TextStyle(fontWeight: FontWeight.bold)),
              YearRangeFilterWidget(
                selectedYearRange: _selectedYearRange,
                onYearRangeChanged: (range) => setState(() => _selectedYearRange = range),
                minYear: _minYear,
                maxYear: _maxYear,
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: _findDatabases,
                  child: const Text('Найти документы'),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Результаты поиска
            if (_showResults) ...[
              const Divider(),
              const Text('Найденные базы данных:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._foundDatabases.map((db) => ListTile(
                title: Text(db),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    // Заглушка для загрузки
                    _showError('Начата загрузка $db');
                  },
                ),
              )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Переход на экран загрузки
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const DocumentDownloadScreen(),
                  ));
                },
                child: const Text('Загрузить все'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}