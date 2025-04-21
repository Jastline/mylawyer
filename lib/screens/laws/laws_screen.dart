import 'package:flutter/material.dart';
import '../../data/db_helper.dart';
import '../../models/law_article.dart';
import 'article_detail_screen.dart';

class LawsScreen extends StatefulWidget {
  const LawsScreen({super.key});

  @override
  State<LawsScreen> createState() => _LawsScreenState();
}

class _LawsScreenState extends State<LawsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<LawArticle> _articles = [];
  List<LawArticle> _filteredArticles = [];
  String _query = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLaws();
  }

  Future<void> _loadLaws() async {
    try {
      final articles = await _dbHelper.getAllLaws();
      setState(() {
        _articles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: ${e.toString()}')),
      );
    }
  }

  void _search(String query) {
    setState(() {
      _query = query.toLowerCase();
      _filteredArticles = _query.isEmpty
          ? _articles
          : _articles.where((article) {
        return article.title.toLowerCase().contains(_query) ||
            article.content.toLowerCase().contains(_query) ||
            article.code.toLowerCase().contains(_query) ||
            article.articleNumber.toLowerCase().contains(_query) ||
            article.chapter.toLowerCase().contains(_query);
      }).toList();
    });
  }

  Map<String, List<LawArticle>> _groupByCode(List<LawArticle> articles) {
    final grouped = <String, List<LawArticle>>{};
    for (var article in articles) {
      if (!grouped.containsKey(article.code)) {
        grouped[article.code] = [];
      }
      grouped[article.code]!.add(article);
    }
    return grouped;
  }

  Widget _buildLawItem(BuildContext context, LawArticle article) {
    return ListTile(
      title: Text(
        article.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${article.code}, ${article.articleNumber}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (article.chapter.isNotEmpty)
            Text(
              article.chapter,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedArticles = _groupByCode(_filteredArticles);

    return Scaffold(
      appBar: AppBar(
        title: const Text('База законов'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Поиск по статьям...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredArticles.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _query.isEmpty ? 'Нет загруженных законов' : 'Ничего не найдено',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: groupedArticles.length,
                itemBuilder: (context, index) {
                  final code = groupedArticles.keys.elementAt(index);
                  final articles = groupedArticles[code]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          code,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          ...articles.map((article) => _buildLawItem(context, article)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadLaws,
        child: const Icon(Icons.refresh),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}