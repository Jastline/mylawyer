import 'package:flutter/material.dart';
import '../resources/resources.dart';


class ProfileHeader extends StatefulWidget {
  @override
  __ProfileHeaderState createState() => __ProfileHeaderState();
}

class __ProfileHeaderState extends State<ProfileHeader> {
  // Для демонстрации храним данные локально
  String _avatarPath = 'assets/images/default_avatar.png';
  String _userName = 'Имя пользователя';

  // Функция для обновления аватара (с использованием ImagePicker или аналогичного пакета)
  void _updateAvatar() {
    // TODO: Реализовать логику выбора изображения
  }

  void _updateUserName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Введите новое имя'),
        content: TextField(
          onChanged: (value) {},
          decoration: InputDecoration(hintText: 'Новое имя'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // Логика для сохранения имени
              Navigator.of(context).pop(_userName);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _userName = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _updateAvatar,  // При клике на аватар, вызываем обновление
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.avatarBackground(context),
            backgroundImage: AssetImage(_avatarPath),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _updateUserName,  // При клике на имя, вызываем редактирование имени
          child: Text(_userName, style: AppTextStyles.title(context)),
        ),
      ],
    );
  }
}
