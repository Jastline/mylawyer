import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_text_styles.dart';
import '../data/db_helper.dart';
import 'test_detail_screen.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<TestModel> _tests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    final tests = await _dbHelper.getAllTests();
    setState(() {
      _tests = tests;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тесты по праву', style: AppTextStyles.appBarTitle),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null, // TODO: Реализовать поиск
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tests.isEmpty
          ? _buildEmptyState()
          : _buildTestsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // TODO: Добавить создание теста
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.auto_stories, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text('Тесты не найдены', style: AppTextStyles.title),
          SizedBox(height: 8),
          Text(
            'Добавьте новые тесты через админ-панель',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildTestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _tests.length,
      itemBuilder: (context, index) {
        final test = _tests[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToTestDetail(context, test),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.gavel,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          test.question,
                          style: AppTextStyles.question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.article, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('Статья: ГК РФ', style: AppTextStyles.lawReference),
                      Spacer(),
                      Text(
                        '3 варианта',
                        style: AppTextStyles.optionsCount,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToTestDetail(BuildContext context, TestModel test) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestDetailScreen(test: test),
      ),
    );
  }
}