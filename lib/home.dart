import 'package:c4/models/articalemodel.dart';
import 'package:c4/services/apigetnews.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ArticleModel>> futureArticles;

  @override
  void initState() {
    super.initState();
    // Initialize the futureArticles in initState
    futureArticles = _fetchArticles();
  }

  Future<List<ArticleModel>> _fetchArticles() async {
    try {
      return await NewsService(Dio()).getTopHeadlines();
    } catch (e) {
      // Handle Dio errors or any other exceptions
      print('Error fetching data: $e');
      throw e; // Rethrow the exception to propagate it
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            animation: true,
            radius: 150,
            lineWidth: 15,
            percent: 0.8,
            progressColor: Colors.deepPurple,
            backgroundColor: Colors.deepPurple.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading ....',
            style: TextStyle(color: Colors.amber, fontSize: 33),
          )
        ],
      ),
    );
  }

  Widget _buildArticleList(List<ArticleModel> articles) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  article.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.subTitle!,
                maxLines: 2,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            (snapshot.data as List<ArticleModel>).isEmpty) {
          return const Center(child: Text('No data available.'));
        } else {
          final articles = snapshot.data as List<ArticleModel>;
          return _buildArticleList(articles);
        }
      },
    );
  }
}
