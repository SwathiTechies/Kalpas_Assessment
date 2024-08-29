import 'package:flutter/material.dart';
import 'package:flutter_assement/Model/news_model.dart'; // Make sure this import path is correct

class ArticleDetailPage extends StatelessWidget {
  final Article article;
 final bool isFavourite;

  const ArticleDetailPage({Key? key, required this.article, required this.isFavourite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                if (article.urlToImage != null)
                  Image.network(article.urlToImage!),
                Padding(
                  padding:  EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () {},
                          icon: Icon(Icons.favorite,
                            color: isFavourite?Colors.red:Colors.white,
                            size: 35,)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Text(
              article.title ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month_outlined, color: Colors.grey,)),
                Text(
                  '${article.publishedAt?.toLocal().toString() ?? 'No Date'}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              article.content ?? 'No Content',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
