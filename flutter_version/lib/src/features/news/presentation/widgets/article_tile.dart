import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../pages/news_detail_page.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  const ArticleTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: SizedBox(
          width: 72,
          height: 72,
          child: article.urlToImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.urlToImage!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    // Show a small placeholder while loading and a fallback when error occurs
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 32),
                      );
                    },
                  ),
                )
              : const Center(child: Icon(Icons.image)),
        ),
        title: Text(article.title ?? 'No title'),
        subtitle: Text(article.description ?? ''),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NewsDetailPage(article: article)),
          );
        },
      ),
    );
  }
}
