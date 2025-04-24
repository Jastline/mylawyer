import 'package:flutter/material.dart';
import '../resources/app_text_styles.dart';
import '../resources/app_colors.dart';

class FilterSetsScreen extends StatefulWidget {
  const FilterSetsScreen({super.key});

  @override
  State<FilterSetsScreen> createState() => _FilterSetsScreenState();
}

class _FilterSetsScreenState extends State<FilterSetsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Наборы фильтров', style: AppTextStyles.appBarTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Комбинации'),
            Tab(text: 'Установленные'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCombinationsTab(context),
          _buildInstalledTab(context),
        ],
      ),
    );
  }

  Widget _buildCombinationsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildFilterEditor(context),
          const SizedBox(height: 16),
          Expanded(child: _buildFilterSetList(context)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Логика загрузки по наборам
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Загрузить'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterEditor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Добавить фильтры', style: AppTextStyles.sectionTitle(context)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: const [
            FilterChip(label: Text('Основные'), selected: false, onSelected: null),
            FilterChip(label: Text('Дополнительные'), selected: false, onSelected: null),
            FilterChip(label: Text('ФЗ'), selected: false, onSelected: null),
            FilterChip(label: Text('Указы'), selected: false, onSelected: null),
          ],
        ),
        const SizedBox(height: 8),
        Text('Годы: 2000 – 2005', style: TextStyle(fontSize: 14, color: AppColors.onSurface(context))),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {
            // Добавить набор
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            //foregroundColor: AppColors.onPrimary(context),
          ),
          child: const Text('Добавить набор'),
        ),
      ],
    );
  }

  Widget _buildFilterSetList(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: AppColors.cardBackground(context),
          child: ListTile(
            title: Text('Набор $index', style: AppTextStyles.lawTitle(context)),
            subtitle: Text('Типы: Основные, Годы: 2000–2005', style: AppTextStyles.lawReference(context)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstalledTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            color: AppColors.cardBackground(context),
            child: ListTile(
              title: Text('ФЗ 2021', style: AppTextStyles.lawTitle(context)),
              subtitle: Text('Уже загружено', style: AppTextStyles.lawReference(context)),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Удалить документ
                },
              ),
            ),
          ),
          // Ещё загруженные документы...
        ],
      ),
    );
  }
}
