import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Article>> getTopHeadlines({String country = 'us', String? category, String? q}) async {
    final models = await remoteDataSource.getTopHeadlines(country: country, category: category, q: q);
    return models.map((m) => m as Article).toList();
  }
}
