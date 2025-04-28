import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';

class DocumentDownloadScreen extends StatelessWidget {
  const DocumentDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProviders = context.watch<AppProviders>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: appProviders.downloadProgress / appProviders.totalDocuments,
                    strokeWidth: 8,
                  ),
                ),
                Text(
                  '${appProviders.downloadProgress} / ${appProviders.totalDocuments}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              appProviders.isDownloading ? 'Загрузка документов...' : 'Загрузка остановлена',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: appProviders.isDownloading
                  ? () => context.read<AppProviders>().setIsDownloading(false)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Отменить загрузку'),
            ),
          ],
        ),
      ),
    );
  }
}
