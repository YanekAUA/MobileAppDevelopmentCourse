import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  const ArticleTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: article.urlToImage != null
            ? Image.network(article.urlToImage!, width: 72, fit: BoxFit.cover)
            : const SizedBox(width: 72, child: Icon(Icons.image)),
        title: Text(article.title ?? 'No title'),
        subtitle: Text(article.description ?? ''),
        onTap: () {
          // For Part 1 we keep simple: show snackbar with title
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(article.title ?? ''),
              duration: const Duration(milliseconds: 250),
              clipBehavior: Clip.hardEdge,
              showCloseIcon: true,
            ),
          );
        },
      ),
    );
  }
}
