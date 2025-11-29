import 'package:dio/dio.dart';
import '../config/env_config.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://newsapi.org/v2',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add the apiKey as a default query parameter if provided
    final apiKey = EnvConfig.newsApiKey;
    if (apiKey.isNotEmpty) {
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        options.queryParameters = Map.from(options.queryParameters)..addAll({'apiKey': apiKey});
        return handler.next(options);
      }));
    }

    return DioClient._(dio);
  }
}
