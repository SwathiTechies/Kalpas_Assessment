import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/news_model.dart';
import 'news_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Article> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteArticles = prefs.getStringList('favorites');
    if (favoriteArticles != null) {
      setState(() {
        _favorites = favoriteArticles
            .map((articleJson) => Article.fromJson(jsonDecode(articleJson)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _favorites.isNotEmpty
          ? ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final article = _favorites[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailPage(article: article, isFavourite: true),
                ),
              );
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          article.urlToImage!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Text(
                            article.description!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.calendar_month_outlined, color: Colors.grey),
                              ),
                              Text(
                                '${article.publishedAt?.toLocal().toString() ?? 'No Date'}',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          );
        },
      )
          : Center(child: Text('No favorites added yet.')),
    );
  }
}
