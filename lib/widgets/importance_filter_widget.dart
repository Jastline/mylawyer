import 'package:flutter/material.dart';

class ImportanceFilterWidget extends StatelessWidget {
  final String? selectedImportance;
  final Function(String) onImportanceChanged;

  const ImportanceFilterWidget({
    Key? key,
    required this.selectedImportance,
    required this.onImportanceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final importanceOptions = ['Основной', 'Дополнительный'];

    return DropdownButton<String>(
      value: selectedImportance,
      onChanged: (value) => onImportanceChanged(value!),
      items: importanceOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
