import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class YandexDiskService {
  static const String _baseUrl = 'https://cloud-api.yandex.net/v1/disk/public/resources';
  static const String _publicUrl = 'https://disk.yandex.ru/d/p3uxHz8DDCnmkA';  // Полный URL для ключа

  Future<List<String>> fetchDocumentTypes(String importance) async {
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl?public_key=$_publicUrl&path=/$importance')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load document types: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['_embedded'] == null || data['_embedded']['items'] == null) {
        return [];
      }

      // Явное приведение типов и проверка
      final items = data['_embedded']['items'] as List;
      return items
          .where((item) => item is Map<String, dynamic> && item['type'] == 'dir')
          .map<String>((item) => item['name'].toString())
          .toList();
    } catch (e) {
      throw Exception('Error fetching document types: $e');
    }
  }

  Future<List<int>> fetchAvailableYears(String importance, String docType) async {
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl?public_key=$_publicUrl&path=/$importance/$docType')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load years: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data['_embedded'] == null || data['_embedded']['items'] == null) {
        return [];
      }

      final items = data['_embedded']['items'] as List;
      final years = items
          .where((item) => item is Map<String, dynamic>
          && item['type'] == 'file'
          && item['name'].toString().endsWith('.db'))
          .map<int?>((item) => int.tryParse(
          item['name'].toString().replaceAll('.db', '')))
          .whereType<int>()
          .toList();

      if (years.isEmpty) return [];

      return [
        years.reduce(math.min),
        years.reduce(math.max)
      ];
    } catch (e) {
      throw Exception('Error fetching available years: $e');
    }
  }

  Future<String> getDatabaseUrl(String importance, String docType, int year) async {
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl/download?public_key=$_publicUrl&path=/$importance/$docType/$year.db')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get download URL: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return data['href'] as String;
    } catch (e) {
      throw Exception('Error getting database URL: $e');
    }
  }

  Future<List<int>> downloadDatabase(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Download failed: ${response.statusCode}');
      }
      return response.bodyBytes;
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDbFiles(String importance) async {
    final List<Map<String, dynamic>> allFiles = [];

    Future<void> _recurse(String path) async {
      final response = await http.get(
          Uri.parse('$_baseUrl?public_key=$_publicUrl&path=$path')
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load path: $path');
      }

      final data = jsonDecode(response.body);
      if (data['_embedded'] == null || data['_embedded']['items'] == null) {
        return;
      }

      final items = data['_embedded']['items'] as List<dynamic>;
      for (var item in items) {
        if (item['type'] == 'dir') {
          await _recurse(item['path']);
        } else if (item['type'] == 'file' && item['name'].toString().endsWith('.db')) {
          final year = int.tryParse(item['name'].toString().replaceAll('.db', ''));
          if (year != null) {
            allFiles.add({
              'name': item['name'],
              'path': item['path'],
              'year': year,
              'type_folder': path.split('/').last,
            });
          }
        }
      }
    }

    await _recurse('/$importance');
    return allFiles;
  }
}
