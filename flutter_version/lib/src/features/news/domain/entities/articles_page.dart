import 'package:equatable/equatable.dart';
import 'article.dart';

class ArticlesPage extends Equatable {
  final List<Article> articles;
  final int totalResults;

  const ArticlesPage({required this.articles, required this.totalResults});

  @override
  List<Object?> get props => [articles, totalResults];
}
