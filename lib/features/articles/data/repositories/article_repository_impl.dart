import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../models/article.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_remote_datasource.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource _remoteDatasource;

  ArticleRepositoryImpl({required ArticleRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticles() async {
    try {
      final articles = await _remoteDatasource.fetchArticles();
      return Right(articles.map(_toEntity).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to load articles: $e'));
    }
  }

  @override
  Future<Either<Failure, ArticleEntity>> getArticle(int id) async {
    try {
      final article = await _remoteDatasource.fetchArticle(id);
      return Right(_toEntity(article));
    } catch (e) {
      return Left(ServerFailure('Failed to load article: $e'));
    }
  }

  ArticleEntity _toEntity(Article model) {
    return ArticleEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      body: model.body,
    );
  }
}
