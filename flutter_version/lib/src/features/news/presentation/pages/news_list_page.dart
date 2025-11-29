import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/util/connectivity.dart';
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
  String? _currentCategory;
  List<Article>? _localSearchResults;
  String? _lastRequestInfo;

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
      context.read<NewsBloc>().add(
        LoadMoreHeadlines(q: _currentQuery, category: _currentCategory),
      );
    }
  }

  void _onSearchChanged(String value) {
    // Debounce user input to avoid firing too many requests
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final q = value.trim().isEmpty ? null : value.trim();
      _currentQuery = q;
      await _performSearch(q);
    });
  }

  Future<void> _performSearch(String? q) async {
    // Try to detect connectivity: if we have no internet but we do have loaded data,
    // perform a local search on already loaded articles (no API request.)
    final hasConnection = await hasInternetConnection();
    if (!hasConnection) {
      final currentState = context.read<NewsBloc>().state;
      if (currentState is NewsLoaded) {
        if (q == null) {
          _localSearchResults = null;
        } else {
          final lq = q.toLowerCase();
          _localSearchResults = currentState.articles.where((a) {
            final title = a.title?.toLowerCase() ?? '';
            final desc = a.description?.toLowerCase() ?? '';
            return title.contains(lq) || desc.contains(lq);
          }).toList();
        }
        setState(() {});
        return;
      }
      // No connection and no cached data => show no results message by clearing list
      _localSearchResults = [];
      setState(() {});
      return;
    }

    // Otherwise, perform the normal API search
    _localSearchResults = null;
    _lastRequestInfo = 'q: ${q ?? ''}, category: ${_currentCategory ?? 'all'}';
    context.read<NewsBloc>().add(
      FetchTopHeadlines(q: q, category: _currentCategory),
    );
    setState(() {});
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
        _localSearchResults = null;
        context.read<NewsBloc>().add(
          FetchTopHeadlines(category: _currentCategory),
        );
        setState(() {});
      }
    }
  }

  String _categoryLabel(String? category) {
    switch (category) {
      case 'business':
        return 'Business';
      case 'entertainment':
        return 'Entertainment';
      case 'general':
        return 'General';
      case 'health':
        return 'Health';
      default:
        return 'Top Headlines';
    }
  }

  void _clearSearch() async {
    _searchController.clear();
    _currentQuery = null;
    _debounce?.cancel();
    _localSearchResults = null;
    final hasConnection = await hasInternetConnection();
    if (hasConnection) {
      context.read<NewsBloc>().add(
        FetchTopHeadlines(category: _currentCategory),
      );
    } else {
      // Keep the currently loaded articles visible (no API call when offline)
      setState(() {});
    }
    setState(() {});
  }

  Future<void> _showFilterDialog() async {
    final parentContext = context;
    final categories = <String?>[
      null,
      'business',
      'entertainment',
      'general',
      'health',
    ];
    final labels = <String>[
      'All',
      'Business',
      'Entertainment',
      'General',
      'Health',
    ];
    String? tempSelected = _currentCategory;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filter by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var i = 0; i < categories.length; i++)
                      RadioListTile<String?>(
                        title: Text(labels[i]),
                        value: categories[i],
                        groupValue: tempSelected,
                        onChanged: (val) {
                          setModalState(() {
                            tempSelected = val;
                          });
                        },
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Apply the selection and re-run the search using the
                            // existing query (if any). We don't clear the search
                            // text here — the user expects the filter to be applied
                            // on the current search text or the default list.
                            setState(() {
                              _currentCategory = tempSelected;
                              _localSearchResults = null;
                            });
                            parentContext.read<NewsBloc>().add(
                              FetchTopHeadlines(
                                q: _currentQuery,
                                category: _currentCategory,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _currentCategory == null
                                      ? 'Showing all categories'
                                      : 'Filtering by ${_categoryLabel(_currentCategory)}',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                decoration: InputDecoration(
                  hintText: 'Search headlines...',
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.playlist_remove_sharp),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
                onChanged: _onSearchChanged,
                onSubmitted: (v) async {
                  final q = v.trim().isEmpty ? null : v.trim();
                  _currentQuery = q;
                  await _performSearch(q);
                },
              )
            : Text(
                _currentCategory == null
                    ? 'Top Headlines'
                    : 'Top Headlines • ${_categoryLabel(_currentCategory)}',
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: _lastRequestInfo != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(20.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.black12,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text(
                    _lastRequestInfo!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
            : null,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            final List<Article> articles = state.articles;
            final displayedArticles =
                (_localSearchResults != null && _currentQuery != null)
                ? _localSearchResults!
                : articles;
            if (displayedArticles.isEmpty) {
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
                  FetchTopHeadlines(
                    q: _currentQuery,
                    category: _currentCategory,
                  ),
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    displayedArticles.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= displayedArticles.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ArticleTile(article: displayedArticles[index]);
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
                      FetchTopHeadlines(
                        q: _currentQuery,
                        category: _currentCategory,
                      ),
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
          context.read<NewsBloc>().add(
            FetchTopHeadlines(q: _currentQuery, category: _currentCategory),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
