class Article {
  final int id;
  final String title;
  final String body;
  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.body,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}