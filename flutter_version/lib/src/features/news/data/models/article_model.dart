import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    super.sourceName,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        sourceName: (json['source'] ?? {})['name'] as String?,
        author: json['author'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        url: json['url'] as String?,
        urlToImage: json['urlToImage'] as String?,
        publishedAt: json['publishedAt'] != null ? DateTime.tryParse(json['publishedAt']) : null,
      );
}
