import 'package:flutter/material.dart';
import 'document_search_screen.dart';
import 'document_download_screen.dart';
import 'document_installed_screen.dart';

class DocumentLoadingWrapperScreen extends StatefulWidget {
  const DocumentLoadingWrapperScreen({super.key});

  @override
  State<DocumentLoadingWrapperScreen> createState() => _DocumentLoadingWrapperScreenState();
}

class _DocumentLoadingWrapperScreenState extends State<DocumentLoadingWrapperScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузка документов'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Поиск'),
            Tab(text: 'Загрузка'),
            Tab(text: 'Установленные'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DocumentSearchScreen(),
          DocumentDownloadScreen(),
          DocumentInstalledScreen(),
        ],
      ),
    );
  }
}
