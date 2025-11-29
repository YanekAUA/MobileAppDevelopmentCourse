import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/article.dart';

class NewsDetailPage extends StatelessWidget {
  final Article article;
  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 64),
              ),
            const SizedBox(height: 12),
            Text(
              article.title ?? 'No title',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                if (article.sourceName != null)
                  Row(
                    children: [
                      Text(
                        article.sourceName!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (article.sourceId != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${article.sourceId})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                if (article.author != null) ...[
                  const SizedBox(width: 8),
                  Text('— ${article.author!}'),
                ],
                if (article.publishedAt != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    '· ${article.publishedAt!.toLocal().toString().split('.').first}',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              article.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (article.content != null && article.content!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    article.content!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            const SizedBox(height: 12),
            if (article.url != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.url!,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: article.url!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Article URL copied to clipboard'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
