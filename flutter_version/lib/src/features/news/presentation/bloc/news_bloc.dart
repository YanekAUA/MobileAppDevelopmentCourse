import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_version/src/core/util/app_logger.dart';
import '../../domain/usecases/get_top_headlines.dart';
import '../../domain/entities/article.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;
  int _totalResults = 0;
  String? _currentQuery;

  NewsBloc({required this.getTopHeadlines}) : super(NewsInitial()) {
    on<FetchTopHeadlines>(_onFetchTopHeadlines);
    on<LoadMoreHeadlines>(_onLoadMoreHeadlines);
    on<SearchHeadlines>(_onSearchHeadlines);
  }

  Future<void> _onFetchTopHeadlines(
    FetchTopHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    _currentPage = 1;
    _hasReachedMax = false;
    AppLogger.logger.d(
      'NewsBloc: FetchTopHeadlines fired, category: ${event.category}, q: ${event.q}',
    );
    try {
      final pageResult = await getTopHeadlines(
        country: 'us',
        category: event.category,
        q: event.q,
        page: _currentPage,
        pageSize: _pageSize,
      );
      final articles = pageResult.articles;
      _totalResults = pageResult.totalResults;
      AppLogger.logger.d(
        'NewsBloc: Received ${articles.length} articles for page=$_currentPage (totalResults=$_totalResults)',
      );
      if (articles.length >= _totalResults) _hasReachedMax = true;
      emit(NewsLoaded(articles, hasReachedMax: _hasReachedMax));
    } catch (e) {
      AppLogger.logger.e('NewsBloc: Error while fetching headlines -> $e');
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreHeadlines(
    LoadMoreHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    if (_hasReachedMax || _isFetchingMore) return;
    AppLogger.logger.d('NewsBloc: LoadMoreHeadlines fired');
    final currentState = state;
    if (currentState is NewsLoaded) {
      _isFetchingMore = true;
      emit(
        NewsLoaded(
          currentState.articles,
          hasReachedMax: currentState.hasReachedMax,
          isLoadingMore: true,
        ),
      );
      try {
        final nextPage = _currentPage + 1;
        final pageResult = await getTopHeadlines(
          country: 'us',
          category: event.category,
          q: _currentQuery ?? event.q,
          page: nextPage,
          pageSize: _pageSize,
        );
        final newArticles = pageResult.articles;
        _totalResults = pageResult.totalResults;
        AppLogger.logger.d(
          'NewsBloc: Received ${newArticles.length} articles for page=$nextPage',
        );
        if (newArticles.isEmpty) {
          _hasReachedMax = true;
          emit(
            NewsLoaded(
              currentState.articles,
              hasReachedMax: true,
              isLoadingMore: false,
            ),
          );
        } else {
          _currentPage = nextPage;
          final all = List<Article>.from(currentState.articles)
            ..addAll(newArticles);
          if (all.length >= _totalResults) _hasReachedMax = true;
          emit(
            NewsLoaded(
              all,
              hasReachedMax: _hasReachedMax,
              isLoadingMore: false,
            ),
          );
        }
      } catch (e) {
        AppLogger.logger.e(
          'NewsBloc: Error while loading more headlines -> $e',
        );
        emit(NewsError(e.toString()));
      }
      _isFetchingMore = false;
    }
  }
}

  Future<void> _onSearchHeadlines(
    SearchHeadlines event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    _currentPage = 1;
    _hasReachedMax = false;
    _currentQuery = event.q;
    AppLogger.logger.d('NewsBloc: SearchHeadlines fired, q: ${event.q}');
    try {
      final pageResult = await getTopHeadlines(
        country: 'us',
        q: _currentQuery,
        page: _currentPage,
        pageSize: _pageSize,
      );
      final articles = pageResult.articles;
      _totalResults = pageResult.totalResults;
      AppLogger.logger.d('NewsBloc: Search got ${articles.length} items (totalResults=$_totalResults)');
      if (articles.length >= _totalResults) _hasReachedMax = true;
      emit(NewsLoaded(articles, hasReachedMax: _hasReachedMax));
    } catch (e) {
      AppLogger.logger.e('NewsBloc: Error while searching headlines -> $e');
      emit(NewsError(e.toString()));
    }
  }
