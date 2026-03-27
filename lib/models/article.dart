class Article {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Article({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
