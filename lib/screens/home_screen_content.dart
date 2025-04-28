import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_providers.dart';
import '../resources/resources.dart';
import '../widgets/law_card.dart';
import '../widgets/section_header.dart';
import '../services/document_search_service.dart';
import 'document_screen.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String searchQuery = '';
  late final DocumentSearchService _searchService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchService = DocumentSearchService(context);
  }

  @override
  Widget build(BuildContext context) {
    final appProviders = context.watch<AppProviders>();
    final selectedFilters = appProviders.filters;
    final yearRange = appProviders.yearRange;
    final documents = _searchService.searchDocuments(
      searchQuery: searchQuery,
      importance: appProviders.selectedImportance,
      docType: appProviders.selectedDocType,
      yearRange: yearRange,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Поиск по документам'),
          const SizedBox(height: 8),
          _buildSearchField(),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Фильтры'),
          const SizedBox(height: 8),
          _buildFilterChips(selectedFilters),
          const SizedBox(height: 16),
          _buildYearSelector(yearRange),
          const SizedBox(height: 24),
          _buildDownloadButton(),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Документы'),
          const SizedBox(height: 8),
          Expanded(
            child: documents.isEmpty
                ? const Center(child: Text('Документы не найдены'))
                : ListView.builder(
              padding: EdgeInsets.zero,
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
      style: AppTextStyles.subtitle(context),
      decoration: InputDecoration(
        hintText: 'Введите название или номер...',
        prefixIcon: Icon(Icons.search, color: AppColors.iconColor(context)),
        filled: true,
        fillColor: AppColors.surfaceBackground(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildFilterChips(Set<String> selectedFilters) {
    const availableFilters = ['Основные', 'Дополнительные', 'Указы', 'Федеральные законы'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableFilters.map((filter) {
        final isSelected = selectedFilters.contains(filter);
        return FilterChip(
          label: Text(
            filter,
            style: TextStyle(
              fontFamily: 'EB Garamond',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.onSurface(context),
            ),
          ),
          selected: isSelected,
          onSelected: (_) => context.read<AppProviders>().toggleFilter(filter),
          selectedColor: AppColors.primary(context),
          backgroundColor: AppColors.unselectedFilterBackground(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      }).toList(),
    );
  }

  Widget _buildYearSelector(RangeValues yearRange) {
    return Row(
      children: [
        Text('Годы:', style: AppTextStyles.subtitle(context)),
        const SizedBox(width: 8),
        Text(
          '${yearRange.start.toInt()} - ${yearRange.end.toInt()}',
          style: AppTextStyles.lawReference(context),
        ),
      ],
    );
  }

  Widget _buildDownloadButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _downloadDocuments,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Загрузить документы',
            style: AppTextStyles.buttonText(context),
          ),
        ),
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
