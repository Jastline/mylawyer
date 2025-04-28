import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../resources/resources.dart';
import '../widgets/theme_switch_button.dart';
import 'document_loading_wrapper_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'home_screen_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProviders = context.watch<AppProviders>();
    final selectedIndex = appProviders.tabIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(selectedIndex),
          style: AppTextStyles.appBarTitle,
        ),
        actions: const [ThemeSwitchButton()],
      ),
      body: _getScreen(selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(isDark, context),
    );
  }

  String _getAppBarTitle(int index) {
    const titles = ['Главная', 'Загрузка', 'Профиль', 'Настройки'];
    return titles[index];
  }

  Widget _getScreen(int index) {
    const screens = [
      HomeScreenContent(),
      DocumentLoadingWrapperScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];
    return screens[index];
  }

  BottomNavigationBar _buildBottomNavBar(bool isDark, BuildContext context) {
    final appProviders = context.watch<AppProviders>();

    return BottomNavigationBar(
      currentIndex: appProviders.tabIndex,
      onTap: (index) => context.read<AppProviders>().setTabIndex(index),
      selectedItemColor: AppColors.primary(context),
      unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
      backgroundColor: AppColors.surfaceBackground(context),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download_rounded),
          label: 'Загрузка',
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
    );
  }
}
