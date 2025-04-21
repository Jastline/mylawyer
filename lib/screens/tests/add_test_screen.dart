import 'package:flutter/material.dart';
import '../../models/test_model.dart';
import '../../data/db_helper.dart';
import '../../resources/app_text_styles.dart';

class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _optionControllers = List.generate(4, (_) => TextEditingController());
  final _lawReferenceController = TextEditingController();
  int _correctIndex = 0;

  final DBHelper _dbHelper = DBHelper();

  @override
  void dispose() {
    _questionController.dispose();
    _lawReferenceController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveTest() async {
    if (_formKey.currentState!.validate()) {
      final test = TestModel(
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        correctIndex: _correctIndex,
        lawReference: _lawReferenceController.text,
      );
      await _dbHelper.insertTest(test);
      Navigator.pop(context, true); // true — чтобы потом перезагрузить список
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать тест', style: AppTextStyles.appBarTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Вопрос'),
                validator: (value) => value == null || value.isEmpty ? 'Введите вопрос' : null,
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < 4; i++) ...[
                TextFormField(
                  controller: _optionControllers[i],
                  decoration: InputDecoration(labelText: 'Вариант ${i + 1}'),
                  validator: (value) => value == null || value.isEmpty ? 'Введите вариант' : null,
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _correctIndex,
                items: List.generate(
                  4,
                      (index) => DropdownMenuItem(
                    value: index,
                    child: Text('Правильный вариант: ${index + 1}'),
                  ),
                ),
                onChanged: (value) => setState(() => _correctIndex = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lawReferenceController,
                decoration: const InputDecoration(labelText: 'Правовая ссылка'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTest,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
