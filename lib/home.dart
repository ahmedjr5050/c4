import 'package:c4/models/articalemodel.dart';
import 'package:c4/services/apigetnews.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var future;
  @override
  void initState() {
    super.initState();
    future = NewsService(Dio()).getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  animation: true,
                  animationDuration: 10000,
                  radius: 150,
                  lineWidth: 40,
                  percent: 0.8,
                  progressColor: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Loading ....',
                  style: TextStyle(color: Colors.amber, fontSize: 33),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          } else {
            List<ArticleModel> articles = (snapshot.data as List<ArticleModel>);

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
                  ArticleModel article = articles[index];
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
                      const SizedBox(
                        height: 12,
                      ),
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
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        article.subTitle!,
                        maxLines: 2,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        });
  }
}
