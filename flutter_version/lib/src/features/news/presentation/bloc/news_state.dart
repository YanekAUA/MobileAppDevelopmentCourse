import '../../domain/entities/article.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasReachedMax;
  final bool isLoadingMore;

  NewsLoaded(
    this.articles, {
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
