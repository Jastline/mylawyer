import 'package:flutter/material.dart';
import '../resources/app_text_styles.dart';
import '../resources/app_colors.dart'; // Убедитесь, что это импортировано

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.avatarBackground(context), // Используем context для фона
                  backgroundImage: const AssetImage('assets/images/default_avatar.png'),
                ),
                const SizedBox(height: 10),
                Text('Имя пользователя', style: AppTextStyles.title(context)),
                Text('my@mail.ru', style: AppTextStyles.subtitle(context)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          Text('Статистика', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 10),
          _buildStatTile('Прочитано законов', '12', context),
          _buildStatTile('Любимые года', '2001, 2007, 2012', context),
          _buildStatTile('Время чтения', '1 ч 43 мин', context),
          _buildStatTile('Закладок', '4', context),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value, BuildContext context) {
    return ListTile(
      title: Text(title, style: AppTextStyles.question(context)),
      trailing: Text(value, style: AppTextStyles.answer(context)),
    );
  }
}
