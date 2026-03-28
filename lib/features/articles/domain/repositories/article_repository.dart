import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getArticles();
  Future<Either<Failure, ArticleEntity>> getArticle(int id);
}
