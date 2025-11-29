import 'package:dio/dio.dart';
import '../config/env_config.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.newsBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add a logger interceptor for debugging network calls
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Add the apiKey as a default query parameter if provided
    final apiKey = EnvConfig.newsApiKey;
    if (apiKey.isNotEmpty) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.queryParameters = Map.from(options.queryParameters)
              ..addAll({'apiKey': apiKey});
            return handler.next(options);
          },
        ),
      );
    }

    return DioClient._(dio);
  }
}
