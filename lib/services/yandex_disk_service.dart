import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class YandexDiskService {
  static const String _baseUrl = 'https://cloud-api.yandex.net/v1/disk/public';
  static const String _publicKey = 'p3uxHz8DDCnmkA'; // Только ключ без полного URL

  Future<List<String>> fetchDocumentTypes(String importance) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/resources?public_key=$_publicKey&path=/$importance&limit=1000'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load document types: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final items = data['_embedded']['items'] as List;

      return items
          .where((item) => item['type'] == 'dir')
          .map((item) => p.basename(item['path']))
          .toList();
    } catch (e) {
      throw Exception('Error fetching document types: $e');
    }
  }

  Future<List<int>> fetchAvailableYears(String importance, String docType) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/resources?public_key=$_publicKey&path=/$importance/$docType&limit=1000'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load years: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final items = data['_embedded']['items'] as List;

      final years = items
          .where((item) => item['type'] == 'file' && item['name'].endsWith('.db'))
          .map((item) => int.tryParse(p.basenameWithoutExtension(item['name'])))
          .where((year) => year != null)
          .cast<int>()
          .toList();

      if (years.isEmpty) return [];

      years.sort();
      return [years.first, years.last];
    } catch (e) {
      throw Exception('Error fetching available years: $e');
    }
  }

  Future<String> getDatabaseUrl(String importance, String docType, int year) async {
    try {
      final response = await http.get(Uri.parse(
          '$_baseUrl/resources/download?public_key=$_publicKey&path=/$importance/$docType/$year.db'));

      if (response.statusCode != 200) {
        throw Exception('Failed to get download URL: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return data['href'];
    } catch (e) {
      throw Exception('Error getting database URL: $e');
    }
  }
}