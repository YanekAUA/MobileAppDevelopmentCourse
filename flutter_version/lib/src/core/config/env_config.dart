import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static String get newsBaseUrl =>
      dotenv.env['NEWS_BASE_URL'] ?? 'https://newsapi.org/v2';
}
