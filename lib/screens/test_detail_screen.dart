import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_styles.dart';

class TestDetailScreen extends StatefulWidget {
  final TestModel test;

  const TestDetailScreen({super.key, required this.test});

  @override
  State<TestDetailScreen> createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  int? _selectedIndex;
  bool _isAnswered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тестирование', style: AppTextStyles.appBarTitle),
        actions: const [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withAlpha(50),
                  width: 1,
                ),
              ),
              child: Text(
                widget.test.question,
                style: AppTextStyles.question,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Варианты ответов:',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 12),
            ...List.generate(widget.test.options.length, (index) {
              final isSelected = _selectedIndex == index;
              final isCorrect = widget.test.correctIndex == index;

              Color backgroundColor = Colors.transparent;
              Color borderColor = Colors.grey.withAlpha(76);
              Color textColor = AppColors.textPrimary;
              IconData icon = Icons.radio_button_unchecked;
              Color iconColor = Colors.grey;

              if (_isAnswered) {
                if (isCorrect) {
                  backgroundColor = AppColors.correct.withAlpha(25);
                  borderColor = AppColors.correct;
                  textColor = AppColors.correct;
                  icon = Icons.check_circle;
                  iconColor = AppColors.correct;
                } else if (isSelected) {
                  backgroundColor = AppColors.incorrect.withAlpha(25);
                  borderColor = AppColors.incorrect;
                  textColor = AppColors.incorrect;
                  icon = Icons.cancel;
                  iconColor = AppColors.incorrect;
                }
              } else if (isSelected) {
                backgroundColor = AppColors.primary.withAlpha(25);
                borderColor = AppColors.primary;
                textColor = AppColors.primary;
                icon = Icons.radio_button_checked;
                iconColor = AppColors.primary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: backgroundColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _isAnswered ? null : () => setState(() {
                      _selectedIndex = index;
                      _isAnswered = true;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: iconColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.test.options[index],
                              style: AppTextStyles.answer.copyWith(color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lawBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.gavel, color: AppColors.lawIcon),
                        SizedBox(width: 8),
                        Text('Правовая основа:', style: AppTextStyles.lawTitle),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('ст. 17 ГК РФ', style: AppTextStyles.lawReference),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}