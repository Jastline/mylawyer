import 'package:flutter/material.dart';
import '../resources/app_text_styles.dart';  // Импорт стилей

class StatisticsBlock extends StatelessWidget {
  const StatisticsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Статистика', style: AppTextStyles.sectionTitle(context)),
        const SizedBox(height: 10),
        // TODO: Подключить данные для статистики
        _buildStatTile('Прочитано законов', '12', context),
        _buildStatTile('Любимые года', '2001, 2007, 2012', context),
        _buildStatTile('Время чтения', '1 ч 43 мин', context),
        _buildStatTile('Закладок', '4', context),
      ],
    );
  }

  Widget _buildStatTile(String title, String value, BuildContext context) {
    return ListTile(
      title: Text(title, style: AppTextStyles.question(context)),
      trailing: Text(value, style: AppTextStyles.answer(context)),
    );
  }
}
