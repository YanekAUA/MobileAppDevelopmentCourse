import '../entities/articles_page.dart';

abstract class NewsRepository {
  Future<ArticlesPage> getTopHeadlines({
    String country = 'us',
    String? category,
    String? q,
    int page = 1,
    int pageSize = 20,
  });
}
