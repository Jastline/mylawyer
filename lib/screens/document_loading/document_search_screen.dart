import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Для работы с датами

class DocumentSearchScreen extends StatefulWidget {
  const DocumentSearchScreen({super.key});

  @override
  _DocumentSearchScreenState createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  String? selectedImportance = 'Основной';
  String? selectedDocType;
  RangeValues selectedYearRange = RangeValues(1900, 2023);

  final List<String> importanceOptions = ['Основной', 'Дополнительный'];
  final List<String> docTypes = []; // Заполняется после парсинга Яндекс.Диска

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск документов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Выбор важности
            DropdownButton<String>(
              value: selectedImportance,
              onChanged: (value) {
                setState(() {
                  selectedImportance = value;
                  docTypes.clear(); // Очистка типов документов при изменении важности
                });
                _loadDocTypes();
              },
              items: importanceOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // 2. Выбор типа документа
            if (docTypes.isNotEmpty)
              DropdownButton<String>(
                value: selectedDocType,
                onChanged: (value) {
                  setState(() {
                    selectedDocType = value;
                  });
                },
                items: docTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            // 3. Выбор диапазона годов
            RangeSlider(
              values: selectedYearRange,
              min: 1900,
              max: 2023,
              divisions: 123,
              labels: RangeLabels(
                selectedYearRange.start.round().toString(),
                selectedYearRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  selectedYearRange = values;
                });
              },
            ),

            const SizedBox(height: 20),

            // 4. Кнопка для загрузки
            ElevatedButton(
              onPressed: _downloadDocuments,
              child: const Text('Загрузить документы'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Заглушка для загрузки документов
  void _downloadDocuments() {
    // Загрузить документы, которые соответствуют выбранным фильтрам
    // Для теста, просто выводим данные в консоль
    print('Загрузка документов с фильтром:');
    print('Важность: $selectedImportance');
    print('Тип документа: $selectedDocType');
    print('Диапазон годов: ${selectedYearRange.start} - ${selectedYearRange.end}');
  }

  // 6. Парсинг Яндекс.Диска для получения типов документов
  void _loadDocTypes() {
    // Здесь добавьте код для парсинга папок с Яндекс.Диска
    // Например, запросите структуру папок и получите доступные типы документов
    // Для заглушки мы просто добавим несколько типов документов
    setState(() {
      docTypes.addAll([
        'Закон',
        'Указ',
        'Постановление',
      ]);
    });
  }
}
