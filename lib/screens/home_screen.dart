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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDisclaimer());
  }

  Future<void> _checkDisclaimer() async {
    final appProviders = context.read<AppProviders>();
    if (!appProviders.disclaimerShown) {
      await _showDisclaimerDialog();
      appProviders.setDisclaimerShown(true);
    }
  }

  Future<void> _showDisclaimerDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Внимание!', style: AppTextStyles.title(context)),
        content: Text(
          'В приложении используются юридические документы РФ 1991–2023 годов. '
              'Мы не гарантируем их абсолютную актуальность и полноту. '
              'Приложение не является юридической консультацией и не несёт ответственности '
              'за последствия, связанные с использованием информации.\n\n'
              'Нажимая "Принять", вы соглашаетесь с этими условиями.',
          style: AppTextStyles.subtitle(context),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
            ),
            child: Text('Принять', style: AppTextStyles.buttonText(context)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProviders = context.watch<AppProviders>();
    final yearRange = appProviders.yearRange;
    final selectedFilters = appProviders.filters;
    final documents = _getMockDocuments();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            child: ListView.builder(
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

  List<RusLawDocument> _getMockDocuments() {
    return List.generate(5, (index) => RusLawDocument(
      id: index,
      title: 'Федеральный закон №${123 + index}-ФЗ',
      docDate: DateTime(2000 + index).toString(),
      docNumber: '${123 + index}-ФЗ',
      internalNumber: 100 + index,
      isWidelyUsed: true,
      docTypeID: 1,
      statusId: 1,
      authorId: 1,
      issuedById: 1,
      signedById: 1,
    ));
  }
}
