import '../../domain/entities/article.dart';
import '../../domain/entities/articles_page.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ArticlesPage> getTopHeadlines({
    String country = 'us',
    String? category,
    String? q,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await remoteDataSource.getTopHeadlines(
      country: country,
      category: category,
      q: q,
      page: page,
      pageSize: pageSize,
    );
    final articleModels = (result['articles'] as List)
        .cast<ArticleModel>()
        .map((m) => m as Article)
        .toList();
    final totalResults = result['totalResults'] as int? ?? articleModels.length;
    return ArticlesPage(articles: articleModels, totalResults: totalResults);
  }
}
