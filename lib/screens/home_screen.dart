import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../providers/theme_provider.dart';
import 'article_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(themeProvider.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                Provider.of<ArticleProvider>(context, listen: false)
                    .setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<ArticleProvider>(
              builder: (context, provider, child) {
                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(provider.errorMessage!),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            provider.loadArticles();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.isLoading && provider.articles.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.articles.isEmpty) {
                  return const Center(child: Text('No articles found'));
                }

                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  onRefresh: () async {
                    await provider.loadArticles();
                    _refreshController.refreshCompleted();
                  },
                  child: ListView.builder(
                    itemCount: provider.articles.length,
                    itemBuilder: (context, index) {
                      final article = provider.articles[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(article.title),
                          subtitle: Text(
                            article.body.length > 100
                                ? '${article.body.substring(0, 100)}...'
                                : article.body,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              article.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: article.isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              Provider.of<ArticleProvider>(context, listen: false)
                                  .toggleFavorite(article);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetailScreen(article: article),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}