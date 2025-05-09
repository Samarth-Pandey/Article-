import 'package:flutter/foundation.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ArticleProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _errorMessage;

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ArticleProvider() {
    loadArticles();
  }

  Future<void> loadArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await _apiService.fetchArticles();
      await _loadFavorites();
      _filterArticles();
    } catch (e) {
      _errorMessage = 'Failed to load articles. Please check your internet connection.';
      if (kDebugMode) {
        print('Error loading articles: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = await _storageService.loadFavorites();
    for (var article in _articles) {
      article.isFavorite = favoriteIds.contains(article.id);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterArticles();
    notifyListeners();
  }

  void _filterArticles() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = List.from(_articles);
    } else {
      _filteredArticles = _articles.where((article) {
        return article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            article.body.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  Future<void> toggleFavorite(Article article) async {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index].isFavorite = !_articles[index].isFavorite;
      _filterArticles();

      final favoriteIds = _articles.where((a) => a.isFavorite).map((a) => a.id).toList();
      await _storageService.saveFavorites(favoriteIds);

      notifyListeners();
    }
  }

  List<Article> get favoriteArticles {
    return _articles.where((article) => article.isFavorite).toList();
  }
}