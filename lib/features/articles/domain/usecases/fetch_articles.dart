import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class FetchArticles {
  final ArticleRepository repository;

  FetchArticles(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> call() async {
    return repository.getArticles();
  }
}
