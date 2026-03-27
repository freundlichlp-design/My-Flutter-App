import 'package:flutter/foundation.dart';

import '../models/article.dart';
import '../services/article_service.dart';

enum ArticleState { initial, loading, success, error }

class ArticleProvider extends ChangeNotifier {
  final ArticleService _articleService;

  ArticleProvider({ArticleService? articleService})
      : _articleService = articleService ?? ArticleService();

  List<Article> _articles = [];
  Article? _selectedArticle;
  ArticleState _state = ArticleState.initial;
  String? _errorMessage;

  List<Article> get articles => _articles;
  Article? get selectedArticle => _selectedArticle;
  ArticleState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ArticleState.loading;
  bool get hasError => _state == ArticleState.error;
  bool get hasData => _state == ArticleState.success;

  Future<void> loadArticles() async {
    _state = ArticleState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await _articleService.fetchArticles();
      _state = ArticleState.success;
    } catch (e) {
      _state = ArticleState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> loadArticle(int id) async {
    _state = ArticleState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedArticle = await _articleService.fetchArticle(id);
      _state = ArticleState.success;
    } catch (e) {
      _state = ArticleState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  void clearSelectedArticle() {
    _selectedArticle = null;
    notifyListeners();
  }
}
