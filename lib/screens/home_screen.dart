import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../resources/resources.dart';
import '../widgets/law_card.dart';
import '../widgets/section_header.dart';
import '../widgets/theme_switch_button.dart';
import 'document_screen.dart';
import 'document_loading_wrapper_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../services/document_search_service.dart'; // Подключаем твой новый сервис поиска

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

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String searchQuery = "";

  late final DocumentSearchService _searchService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchService = DocumentSearchService(context);
  }

  @override
  Widget build(BuildContext context) {
    final appProviders = context.watch<AppProviders>();
    final yearRange = appProviders.yearRange;
    final selectedFilters = appProviders.filters;
    final documents = _searchService.searchDocuments(searchQuery);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Поиск по документам'),
          _buildSearchField(),
          const SizedBox(height: 10),
          const SectionHeader(title: 'Фильтры'),
          const SizedBox(height: 10),
          _buildFilterChips(selectedFilters),
          const SizedBox(height: 10),
          _buildYearSelector(yearRange),
          const SizedBox(height: 20),
          _buildDownloadButton(),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Документы'),
          const SizedBox(height: 10),
          Expanded(
            child: documents.isEmpty
                ? const Center(child: Text('Документы не найдены'))
                : ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => LawCard(
                document: documents[index],
                onTap: () => _openDocument(documents[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (query) {
        setState(() {
          searchQuery = query;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Поиск',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFilterChips(Set<String> selectedFilters) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const availableFilters = ['Основные', 'Дополнительные', 'Указы', 'Федеральные законы'];

    return Wrap(
      spacing: 8.0,
      children: availableFilters.map((filter) {
        final isSelected = selectedFilters.contains(filter);

        return FilterChip(
          label: Text(filter),
          selected: isSelected,
          onSelected: (selected) => context.read<AppProviders>().toggleFilter(filter),
          selectedColor: isDark
              ? AppColors.primaryDarkSelectedFilter
              : AppColors.primaryLightSelectedFilter,
          backgroundColor: AppColors.unselectedFilterBackground(context),
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColors.onSurface(context),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYearSelector(RangeValues yearRange) {
    return Row(
      children: [
        Text('Годы: ', style: AppTextStyles.subtitle(context)),
        const SizedBox(width: 10),
        Text(
          '${yearRange.start.toInt()} - ${yearRange.end.toInt()}',
          style: AppTextStyles.lawReference(context),
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(context),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: _downloadDocuments,
        child: Text('Загрузить документы', style: AppTextStyles.buttonText(context)),
      ),
    );
  }

  Future<void> _downloadDocuments() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Загрузка документов...')),
    );
  }

  void _openDocument(RusLawDocument document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentScreen(document: document),
      ),
    );
  }
}
