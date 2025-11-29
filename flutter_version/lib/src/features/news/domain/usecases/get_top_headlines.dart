import '../repositories/news_repository.dart';
import '../entities/articles_page.dart';
import 'package:flutter_version/src/core/util/app_logger.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<ArticlesPage> call({
    String country = 'us',
    String? category,
    String? q,
    int page = 1,
    int pageSize = 20,
  }) {
    // Debug: log call parameters
    AppLogger.logger.d(
      'GetTopHeadlines: calling repository with country=$country, category=$category, q=$q',
    );
    return repository.getTopHeadlines(
      country: country,
      category: category,
      q: q,
      page: page,
      pageSize: pageSize,
    );
  }
}
