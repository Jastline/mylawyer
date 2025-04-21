import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileService>(context).profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(context, profile),
            const SizedBox(height: 24),
            _buildStatisticsSection(context, profile),
            const SizedBox(height: 24),
            _buildAchievementsSection(context, profile),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: profile.avatarPath != null
              ? FileImage(File(profile.avatarPath!))
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () => _changeAvatar(context),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => _editName(context),
          child: const Text('Изменить имя'),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статистика',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStatCard('Всего прочитано', '${profile.totalLawsRead} законов'),
        _buildStatCard('Тестов пройдено', profile.testsCompleted.toString()),
        const SizedBox(height: 12),
        ...profile.lawsByCategory.entries.map((e) =>
            _buildCategoryStat(e.key, e.value, profile.timeSpent[e.key] ?? 0),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(BuildContext context, UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Достижения',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (profile.achievements.isEmpty)
          const Text('Пока нет достижений'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.achievements.map((a) =>
              _buildAchievementBadge(a),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStat(String category, int count, int minutes) {
    return ListTile(
      title: Text(category),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count законов'),
          Text('${minutes} мин'),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(Achievement achievement) {
    return Tooltip(
      message: achievement.description,
      child: Chip(
        avatar: Icon(achievement.icon, size: 18),
        label: Text(achievement.title),
      ),
    );
  }

  Future<void> _changeAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && context.mounted) {
      await Provider.of<ProfileService>(context, listen: false)
          .updateAvatar(pickedFile.path);
    }
  }

  Future<void> _editName(BuildContext context) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => NameEditDialog(
        currentName: Provider.of<ProfileService>(context).profile.name,
      ),
    );
    if (newName != null && context.mounted) {
      await Provider.of<ProfileService>(context, listen: false)
          .updateName(newName);
    }
  }
}

class NameEditDialog extends StatelessWidget {
  final String currentName;
  final TextEditingController _controller;

  NameEditDialog({super.key, required this.currentName})
      : _controller = TextEditingController(text: currentName);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Изменить имя'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Имя'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}