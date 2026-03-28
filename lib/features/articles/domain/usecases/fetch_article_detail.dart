import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class FetchArticleDetail {
  final ArticleRepository repository;

  FetchArticleDetail(this.repository);

  Future<Either<Failure, ArticleEntity>> call(int id) async {
    return repository.getArticle(id);
  }
}
