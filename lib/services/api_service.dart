import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Error: $e');
      if (e is http.ClientException || e.toString().contains('SocketException')) {
        throw Exception('No internet connection');
      } else if (e is TimeoutException) {
        throw Exception('Request timed out');
      } else {
        throw Exception('Failed to load articles');
      }
    }
  }
}