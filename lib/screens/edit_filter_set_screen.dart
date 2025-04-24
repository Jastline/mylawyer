import 'package:flutter/material.dart';
import '../resources/app_text_styles.dart';
import '../resources/app_colors.dart';

class EditFilterSetScreen extends StatefulWidget {
  final bool isAlreadyDownloaded;

  const EditFilterSetScreen({super.key, this.isAlreadyDownloaded = false});

  @override
  State<EditFilterSetScreen> createState() => _EditFilterSetScreenState();
}

class _EditFilterSetScreenState extends State<EditFilterSetScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Набор документов');
  final List<String> _types = ['ФЗ', 'Указы'];
  final List<String> _importance = ['Основные', 'Дополнительные'];
  final Set<String> _selectedTypes = {'Основные'};
  String _selectedImportance = 'Средняя';
  int _startYear = 2000;
  int _endYear = 2005;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isAlreadyDownloaded;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать набор'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              enabled: !isDisabled,
              decoration: const InputDecoration(labelText: 'Название набора'),
            ),
            const SizedBox(height: 16),
            Text('Типы документов', style: AppTextStyles.sectionTitle(context)),
            Wrap(
              spacing: 8,
              children: _types.map((type) {
                final selected = _selectedTypes.contains(type);
                return FilterChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: isDisabled
                      ? null
                      : (value) {
                    setState(() {
                      if (value) {
                        _selectedTypes.add(type);
                      } else {
                        _selectedTypes.remove(type);
                      }
                    });
                  },
                  selectedColor: AppColors.selectedFilterBackground(context),
                  backgroundColor: AppColors.unselectedFilterBackground(context),
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Важность', style: AppTextStyles.sectionTitle(context)),
            DropdownButtonFormField<String>(
              value: _selectedImportance,
              onChanged: isDisabled ? null : (val) => setState(() => _selectedImportance = val!),
              items: _importance.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Годы: $_startYear – $_endYear', style: AppTextStyles.lawReference(context)),
            if (!isDisabled) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    _startYear = (_startYear - 1).clamp(1991, _endYear);
                  }),
                  child: const Text('- год от'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _endYear = (_endYear + 1).clamp(_startYear, 2023);
                  }),
                  child: const Text('+ год до'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isDisabled
                  ? null
                  : () {
                // TODO: Проверка, существуют ли документы по выбранным типам, важности и годам
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
