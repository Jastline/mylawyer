import 'package:flutter/material.dart';
import '../../services/yandex_disk_service.dart';

class DocumentSearchScreen extends StatefulWidget {
  @override
  _DocumentSearchScreenState createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  final YandexDiskService _service = YandexDiskService();

  List<String> documentTypes = [];
  bool isLoading = true;
  String? selectedDocumentType;

  @override
  void initState() {
    super.initState();
    _loadDocumentTypes();
  }

  Future<void> _loadDocumentTypes() async {
    try {
      final types = await _service.fetchDocumentTypes(''); // пустой путь вместо publicLink
      setState(() {
        documentTypes = types;
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки типов документов: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onDocumentTypeSelected(String type) {
    setState(() {
      selectedDocumentType = type;
    });

    // Здесь можно сделать загрузку файлов для выбранного типа
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Выбран: $type')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Документы')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: documentTypes.map((type) {
            final isSelected = type == selectedDocumentType;
            return ChoiceChip(
              label: Text(
                type,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
              selected: isSelected,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade300,
              onSelected: (_) => _onDocumentTypeSelected(type),
            );
          }).toList(),
        ),
      ),
    );
  }
}
