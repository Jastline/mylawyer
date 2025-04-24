import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/app_text_styles.dart';
import '../resources/app_colors.dart';
import '../widgets/theme_provider.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'document_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Индекс текущего экрана
  final List<String> _titles = ['Главная', 'Профиль', 'Настройки']; // Список заголовков для вкладок

  final List<Widget> _screens = const [
    HomeScreenContent(),  // Главный экран с фильтрами и документами
    ProfileScreen(),      // Экран профиля
    SettingsScreen(),     // Экран настроек
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: AppTextStyles.appBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Фильтры', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 10),
          _buildFilterChips(context),
          const SizedBox(height: 10),
          _buildYearSelector(context),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Заглушка: логика загрузки документов
              },
              child: const Text('Загрузить документы'),
            ),
          ),
          const SizedBox(height: 20),
          Text('Документы', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 10),
          Expanded(child: _buildDocumentList(context)),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        FilterChip(
          label: const Text('Основные'),
          selected: true,
          onSelected: (selected) {},
          selectedColor: AppColors.selectedFilterBackground(context),
          backgroundColor: AppColors.unselectedFilterBackground(context),
        ),
        FilterChip(
          label: const Text('Дополнительные'),
          selected: false,
          onSelected: (selected) {},
          selectedColor: AppColors.selectedFilterBackground(context),
          backgroundColor: AppColors.unselectedFilterBackground(context),
        ),
        FilterChip(
          label: const Text('Указы'),
          selected: false,
          onSelected: (selected) {},
          selectedColor: AppColors.selectedFilterBackground(context),
          backgroundColor: AppColors.unselectedFilterBackground(context),
        ),
        FilterChip(
          label: const Text('Федеральные законы'),
          selected: false,
          onSelected: (selected) {},
          selectedColor: AppColors.selectedFilterBackground(context),
          backgroundColor: AppColors.unselectedFilterBackground(context),
        ),
      ],
    );
  }

  Widget _buildYearSelector(BuildContext context) {
    return Row(
      children: [
        Text('Годы: ', style: AppTextStyles.subtitle(context)),
        const SizedBox(width: 10),
        Text('с 2000 по 2003', style: AppTextStyles.lawReference(context)),
      ],
    );
  }

  Widget _buildDocumentList(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          color: AppColors.cardBackground(context),
          child: ListTile(
            leading: Icon(Icons.description, color: AppColors.iconColor(context)),
            title: Text('Закон о чём-то важном', style: AppTextStyles.lawTitle(context)),
            subtitle: Text('2001 • №123-ФЗ', style: AppTextStyles.lawReference(context)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DocumentScreen()),
              );
            },
          ),
        );
      },
    );
  }
}
