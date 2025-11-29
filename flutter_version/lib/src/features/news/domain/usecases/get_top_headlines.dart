import '../repositories/news_repository.dart';
import '../entities/article.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<List<Article>> call({String country = 'us', String? category, String? q}) {
    return repository.getTopHeadlines(country: country, category: category, q: q);
  }
}
