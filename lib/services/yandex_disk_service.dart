import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class YandexDiskService {
  static const String _baseUrl = 'https://cloud-api.yandex.net/v1/disk/public/resources';
  static const String _publicKey = 'p3uxHz8DDCnmkA';

  // Получаем список типов документов для выбранной важности
  Future<List<String>> fetchDocumentTypes(String importance) async {
    try {
      final url = Uri.parse('$_baseUrl?public_key=$_publicKey&path=/$importance');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Ошибка ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['_embedded'] == null || data['_embedded']['items'] == null) {
        return [];
      }

      // Получаем только папки (типы документов)
      return (data['_embedded']['items'] as List)
          .where((item) => item['type'] == 'dir')
          .map((item) => p.basename(item['name']))
          .toList();
    } catch (e) {
      throw Exception('Ошибка получения типов документов: $e');
    }
  }

  // Получаем доступные годы для выбранного типа документа
  Future<List<int>> fetchAvailableYears(String importance, String docType) async {
    try {
      final url = Uri.parse('$_baseUrl?public_key=$_publicKey&path=/$importance/$docType');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Ошибка ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['_embedded'] == null || data['_embedded']['items'] == null) {
        return [];
      }

      // Получаем все файлы .db и извлекаем годы из названий
      final years = (data['_embedded']['items'] as List)
          .where((item) => item['type'] == 'file' && item['name'].endsWith('.db'))
          .map((item) => int.tryParse(p.basenameWithoutExtension(item['name'])))
          .where((year) => year != null)
          .cast<int>()
          .toList();

      if (years.isEmpty) return [];

      years.sort();
      return [years.first, years.last]; // Возвращаем минимальный и максимальный год
    } catch (e) {
      throw Exception('Ошибка получения доступных годов: $e');
    }
  }

  // Получаем прямую ссылку для скачивания файла
  Future<String> getDownloadUrl(String importance, String docType, int year) async {
    try {
      final url = Uri.parse('$_baseUrl/download?public_key=$_publicKey&path=/$importance/$docType/$year.db');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Ошибка ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return data['href'];
    } catch (e) {
      throw Exception('Ошибка получения ссылки для скачивания: $e');
    }
  }

  // Скачиваем файл и возвращаем его как List<int> (байты)
  Future<List<int>> downloadDatabase(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Ошибка загрузки файла: ${response.statusCode}');
      }
      return response.bodyBytes;
    } catch (e) {
      throw Exception('Ошибка скачивания базы данных: $e');
    }
  }
}