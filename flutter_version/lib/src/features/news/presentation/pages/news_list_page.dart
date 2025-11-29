import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/article_tile.dart';
import '../../domain/entities/article.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool _isSearching = false;
  String? _currentQuery;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NewsBloc>().add(LoadMoreHeadlines(q: _currentQuery));
    }
  }

  void _onSearchChanged(String value) {
    // Debounce user input to avoid firing too many requests
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final q = value.trim().isEmpty ? null : value.trim();
      _currentQuery = q;
      context.read<NewsBloc>().add(FetchTopHeadlines(q: q));
      // update UI — primarily suffix icon visibility
      setState(() {});
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
    if (_isSearching) {
      // Focus on the input when we enter search mode
      FocusScope.of(context).requestFocus(_searchFocusNode);
    } else {
      // Clear search when leaving search mode
      if (_searchController.text.isNotEmpty) {
        _searchController.clear();
        _currentQuery = null;
        context.read<NewsBloc>().add(FetchTopHeadlines());
        setState(() {});
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _currentQuery = null;
    _debounce?.cancel();
    context.read<NewsBloc>().add(FetchTopHeadlines());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Validate NEWS API key is present; show a message in UI if not
    if (EnvConfig.newsApiKey.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Top Headlines')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'No News API Key',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please create a `.env` with NEWS_API_KEY and restart the app.',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add .env and restart')),
                  ),
                  child: const Text('Info'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // If running on web, NewsAPI denies cross-origin requests — show hint
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Top Headlines')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Note: Running in Web',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'NewsAPI may block web requests (CORS). Run on Android or iOS emulator/simulator, or use a proxy for local web testing.',
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search headlines...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
                onSubmitted: (v) {
                  final q = v.trim().isEmpty ? null : v.trim();
                  _currentQuery = q;
                  context.read<NewsBloc>().add(FetchTopHeadlines(q: q));
                },
              )
            : const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            final List<Article> articles = state.articles;
            if (articles.isEmpty) {
              return Center(
                child: Text(
                  _currentQuery == null
                      ? 'No Results Found'
                      : 'No results for "$_currentQuery"',
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(
                  FetchTopHeadlines(q: _currentQuery),
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: articles.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= articles.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ArticleTile(article: articles[index]);
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<NewsBloc>().add(
                      FetchTopHeadlines(q: _currentQuery),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Pull to load headlines'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NewsBloc>().add(FetchTopHeadlines(q: _currentQuery));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
