import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/statistics_block.dart';  // Импорт нового виджета

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          ProfileHeader(),
          const SizedBox(height: 20),
          const Divider(),
          StatisticsBlock(),  // Вставляем новый виджет статистики
        ],
      ),
    );
  }
}
