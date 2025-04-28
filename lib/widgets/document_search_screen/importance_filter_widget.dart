import 'package:flutter/material.dart';

class ImportanceFilterWidget extends StatelessWidget {
  final String selectedImportance;
  final Function(String) onImportanceChanged;

  const ImportanceFilterWidget({
    Key? key,
    required this.selectedImportance,
    required this.onImportanceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Основной', label: Text('Основной')),
        ButtonSegment(value: 'Дополнительный', label: Text('Дополнительный')),
      ],
      selected: {selectedImportance},
      onSelectionChanged: (selection) => onImportanceChanged(selection.first),
    );
  }
}