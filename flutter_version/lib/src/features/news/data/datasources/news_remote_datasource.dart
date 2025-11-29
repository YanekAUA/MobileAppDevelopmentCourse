import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/article_model.dart';

class NewsRemoteDataSource {
  final DioClient client;
  NewsRemoteDataSource(this.client);

  Future<List<ArticleModel>> getTopHeadlines({String country = 'us', String? category, String? q}) async {
    final dio = client.dio;
    final params = <String, dynamic>{'country': country};
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (q != null && q.isNotEmpty) params['q'] = q;

    final response = await dio.get('/top-headlines', queryParameters: params);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> articles = data['articles'] ?? [];
      return articles.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw DioError(
        requestOptions: RequestOptions(path: '/top-headlines'),
        response: response,
        error: 'Failed to fetch top headlines');
  }
}
