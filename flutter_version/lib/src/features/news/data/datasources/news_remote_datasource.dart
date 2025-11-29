import '../../../../core/network/dio_client.dart';
import '../models/article_model.dart';
import 'package:flutter_version/src/core/util/app_logger.dart';

class NewsRemoteDataSource {
  final DioClient client;
  NewsRemoteDataSource(this.client);

  Future<Map<String, dynamic>> getTopHeadlines({
    String country = 'us',
    String? category,
    String? q,
    int page = 1,
    int pageSize = 20,
  }) async {
    final dio = client.dio;
    final params = <String, dynamic>{
      'country': country,
      'page': page,
      'pageSize': pageSize,
    };
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (q != null && q.isNotEmpty) params['q'] = q;

    try {
      final response = await dio.get('/top-headlines', queryParameters: params);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> articles = data['articles'] ?? [];
        final int totalResults =
            data['totalResults'] as int? ?? articles.length;
        final articleModels = articles
            .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return {'articles': articleModels, 'totalResults': totalResults};
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      AppLogger.logger.e(
        'NewsRemoteDataSource: error calling /top-headlines -> $e',
      );
      rethrow;
    }
  }
}
