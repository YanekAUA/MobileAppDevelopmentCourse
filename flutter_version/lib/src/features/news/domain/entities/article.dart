import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? sourceName;
  final String? sourceId;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  const Article({
    this.sourceName,
    this.sourceId,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  List<Object?> get props => [
    sourceName,
    sourceId,
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
  ];
}
