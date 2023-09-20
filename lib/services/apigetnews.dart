import 'package:c4/models/articalemodel.dart';
import 'package:dio/dio.dart';

class NewsService {
  final Dio dio;

  NewsService(this.dio);

  Future<List<ArticleModel>> getTopHeadlines() async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': '3c88955c487e4d9db668f011dd85e737',
          'category': 'sports',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'];
        final articlesList =
            articles.map((article) => ArticleModel.fromJson(article)).toList();
        return articlesList;
      } else {
        // Handle non-200 status code if needed
        print('HTTP Error: ${response.statusCode} - ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      // Handle Dio errors or any other exceptions
      print('Error fetching data: $e');
      return [];
    }
  }
}
