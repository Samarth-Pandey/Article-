import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Center(
              child: Consumer<ArticleProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton.icon(
                    icon: Icon(
                      article.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: article.isFavorite ? Colors.red : null,
                    ),
                    label: Text(
                      article.isFavorite
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                    ),
                    onPressed: () {
                      provider.toggleFavorite(article);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}