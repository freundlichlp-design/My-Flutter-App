import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class ArticleService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  ArticleService({http.Client? client}) : _client = client ?? http.Client();

  void dispose() => _client.close();

  Future<List<Article>> fetchArticles() async {
    final response = await _client.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => Article.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load articles (${response.statusCode})');
    }
  }

  Future<Article> fetchArticle(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/posts/$id'));

    if (response.statusCode == 200) {
      return Article.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to load article ($id): ${response.statusCode}');
    }
  }
}
