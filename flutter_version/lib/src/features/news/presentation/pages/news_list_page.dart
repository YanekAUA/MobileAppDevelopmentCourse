import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/article_tile.dart';
import '../../domain/entities/article.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines')),
      body: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
        if (state is NewsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsLoaded) {
          final List<Article> articles = state.articles;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NewsBloc>().add(FetchTopHeadlines());
            },
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) => ArticleTile(article: articles[index]),
            ),
          );
        } else if (state is NewsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Pull to load headlines'));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NewsBloc>().add(FetchTopHeadlines());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
