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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NewsBloc>().add(LoadMoreHeadlines());
    }
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
      appBar: AppBar(title: const Text('Top Headlines')),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            final List<Article> articles = state.articles;
            if (articles.isEmpty) {
              return Center(child: Text('No Results Found'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(FetchTopHeadlines());
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
                    onPressed: () =>
                        context.read<NewsBloc>().add(FetchTopHeadlines()),
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
          context.read<NewsBloc>().add(FetchTopHeadlines());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
