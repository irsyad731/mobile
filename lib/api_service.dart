import 'dart:convert';
import 'package:http/http.dart' as http;
import 'article_model.dart';

class ApiService {
  static const _apiKey = '7471976f73c64077b8cb6fcc567680b6';
  static const _baseUrl =
      'https://newsapi.org/v2/everything?q=tesla&from=2025-09-30&sortBy=publishedAt&apiKey=$_apiKey';

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> articlesJson = json['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load article");
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
