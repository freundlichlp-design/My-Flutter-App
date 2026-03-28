import 'package:flutter/foundation.dart';

import '../features/articles/domain/entities/article.dart';
import '../features/articles/domain/usecases/fetch_article_detail.dart';
import '../features/articles/domain/usecases/fetch_articles.dart';

enum ArticleState { initial, loading, success, error }

class ArticleProvider extends ChangeNotifier {
  final FetchArticles _fetchArticles;
  final FetchArticleDetail _fetchArticleDetail;

  ArticleProvider({
    required FetchArticles fetchArticles,
    required FetchArticleDetail fetchArticleDetail,
  })  : _fetchArticles = fetchArticles,
        _fetchArticleDetail = fetchArticleDetail;

  List<ArticleEntity> _articles = [];
  ArticleEntity? _selectedArticle;
  ArticleState _state = ArticleState.initial;
  String? _errorMessage;

  List<ArticleEntity> get articles => _articles;
  ArticleEntity? get selectedArticle => _selectedArticle;
  ArticleState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ArticleState.loading;
  bool get hasError => _state == ArticleState.error;
  bool get hasData => _state == ArticleState.success;

  Future<void> loadArticles() async {
    _state = ArticleState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _fetchArticles();
    result.fold(
      (failure) {
        _state = ArticleState.error;
        _errorMessage = failure.message;
      },
      (articles) {
        _articles = articles;
        _state = ArticleState.success;
      },
    );

    notifyListeners();
  }

  Future<void> loadArticle(int id) async {
    _state = ArticleState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _fetchArticleDetail(id);
    result.fold(
      (failure) {
        _state = ArticleState.error;
        _errorMessage = failure.message;
      },
      (article) {
        _selectedArticle = article;
        _state = ArticleState.success;
      },
    );

    notifyListeners();
  }

  void clearSelectedArticle() {
    _selectedArticle = null;
    notifyListeners();
  }
}
