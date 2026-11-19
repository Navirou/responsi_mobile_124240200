import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class ApiService {
  static const String baseUrl = 'https://kitsu.io/api/edge/anime';
  static const Map<String, String> headers = {
    'Accept': 'application/vnd.api+json',
  };

  /// Fetch list of anime from Kitsu
  static Future<List<Anime>> fetchAnime() async {
    try {
      final uri = Uri.parse('$baseUrl/?page[limit]=20&page[offset]=0');
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> dataList = json['data'] ?? [];
        return dataList.map((item) => Anime.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load anime (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error while fetching anime: $e');
    }
  }

  /// Fetch single anime detail by ID
  static Future<Anime> fetchAnimeDetail(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Anime.fromJson(json['data'] ?? json);
      } else {
        throw Exception('Failed to load anime detail (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error while fetching anime detail: $e');
    }
  }
}
