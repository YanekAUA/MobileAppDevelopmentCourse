import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    super.sourceName,
    super.sourceId,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    sourceName: (json['source'] ?? {})['name'] as String?,
    sourceId: (json['source'] ?? {})['id'] as String?,
    author: json['author'] as String?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    url: json['url'] as String?,
    urlToImage: json['urlToImage'] as String?,
    publishedAt: json['publishedAt'] != null
        ? DateTime.tryParse(json['publishedAt'])
        : null,
    content: json['content'] as String?,
  );
}
