import 'package:flutter/material.dart';
import '../../services/yandex_disk_service.dart';

class DocumentSearchScreen extends StatefulWidget {
  const DocumentSearchScreen({super.key});

  @override
  _DocumentSearchScreen createState() => _DocumentSearchScreen();
}

class _DocumentSearchScreen extends State<DocumentSearchScreen> {
  final YandexDiskService _yandexService = YandexDiskService();

  String _selectedImportance = 'Основной';
  String? _selectedDocType;
  List<String> _docTypes = [];
  List<int> _yearRange = [1950, 2023];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDocumentTypes();
  }

  Future<void> _loadDocumentTypes() async {
    setState(() => _isLoading = true);
    try {
      _docTypes = await _yandexService.fetchDocumentTypes(_selectedImportance);
    } catch (e) {
      _showError('Ошибка загрузки типов документов: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadYearRange() async {
    if (_selectedDocType == null) return;

    setState(() => _isLoading = true);
    try {
      final years = await _yandexService.fetchAvailableYears(
        _selectedImportance,
        _selectedDocType!,
      );

      if (years.isNotEmpty) {
        setState(() => _yearRange = years);
      }
    } catch (e) {
      _showError('Ошибка загрузки диапазона годов: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
        title: const Text('Фильтры документов'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Выбор важности документа
            const Text('Важность документа:'),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Основной'),
                  selected: _selectedImportance == 'Основной',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedImportance = 'Основной';
                        _selectedDocType = null;
                      });
                      _loadDocumentTypes();
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Дополнительный'),
                  selected: _selectedImportance == 'Дополнительный',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedImportance = 'Дополнительный';
                        _selectedDocType = null;
                      });
                      _loadDocumentTypes();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Выбор типа документа
            if (_docTypes.isNotEmpty) ...[
              const Text('Тип документа:'),
              DropdownButtonFormField<String>(
                value: _selectedDocType,
                items: _docTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDocType = value);
                  _loadYearRange();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Выбор диапазона годов
            if (_selectedDocType != null) ...[
              const Text('Диапазон годов:'),
              RangeSlider(
                values: RangeValues(_yearRange[0].toDouble(), _yearRange[1].toDouble()),
                min: _yearRange[0].toDouble(),
                max: _yearRange[1].toDouble(),
                divisions: _yearRange[1] - _yearRange[0],
                labels: RangeLabels(
                  _yearRange[0].toString(),
                  _yearRange[1].toString(),
                ),
                onChanged: (values) {
                  setState(() {
                    _yearRange = [values.start.toInt(), values.end.toInt()];
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            // Кнопка применения фильтров
            Center(
              child: ElevatedButton(
                onPressed: _selectedDocType == null
                    ? null
                    : () {
                  Navigator.pop(context, {
                    'importance': _selectedImportance,
                    'docType': _selectedDocType,
                    'yearRange': _yearRange,
                  });
                },
                child: const Text('Применить фильтры'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}