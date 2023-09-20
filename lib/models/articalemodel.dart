class ArticleModel {
  final String? image;
  final String title;
  final String? subTitle;

  ArticleModel({
    required this.image,
    required this.title,
    required this.subTitle,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      image: json['urlToImage'] as String?,
      title: json['title'] as String,
      subTitle: json['description'] as String?,
    );
  }
}
