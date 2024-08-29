import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assement/Model/news_model.dart';
import '../Services/fetch_data.dart';
import 'news_details_screen.dart';


class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  Future<NewsListModel?>?  _newsData;
  List<Article> _favorites = [];

  @override
  void initState() {
    super.initState();
    _newsData = fetchData() as Future<NewsListModel?>?;
    _loadFavorites();
  }



  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteArticles = prefs.getStringList('favorites');
    if (favoriteArticles != null) {
      setState(() {
        //List<dynamic> jsonList = jsonDecode(favoritesJson);
        _favorites = favoriteArticles.map((jsonItem) => Article.fromJson(jsonDecode(jsonItem))).toList();
      });
      print(_favorites);
    }
  }

  void saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteArticles = _favorites.map((article) => jsonEncode(article.toJson())).toList();
    prefs.setStringList('favorites', favoriteArticles);
  }


  void onFavorite(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? favoriteArticles = prefs.getStringList('favorites');
    List<Article> favorites = favoriteArticles != null
        ? favoriteArticles.map((articleJson) => Article.fromJson(jsonDecode(articleJson))).toList()
        : [];


    if (!favorites.any((favArticle) => favArticle.url == article.url)) {
      favorites.add(article);


      List<String> updatedFavorites = favorites.map((favArticle) => jsonEncode(favArticle.toJson())).toList();
      prefs.setStringList('favorites', updatedFavorites);

      setState(() {
        _favorites = favorites;
      });

      print('Favorite added: ${article.title}');
    } else {
      print('Article is already in favorites: ${article.title}');
    }
  }

  bool isArticleInFavorites(Article article) {
    return _favorites.any((favArticle) => favArticle.url == article.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<NewsListModel?>(
        future: _newsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final articles = snapshot.data?.articles ?? [];
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
               final article = articles[index];
               final isFavourite = isArticleInFavorites(article);
              print(isFavourite);
               return Dismissible(
                  key: Key(article.url ?? ''),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    onFavorite(article);
                    setState(() {
                      articles.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${article.title}\n Added to favorites'),
                      ),
                    );
                  },
                  background: Container(
                    color: Color(0xffF1ADAA),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0, left: 20, top: 40, bottom: 20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 35,
                        ),
                        Text('Added to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('favourite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(article: article, isFavourite:isFavourite),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.only(left: 10, right: 10,bottom: 20),
                      child:ListTile(
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
                  ),
                );
              },
            );
          } else {
            return const Text('No data available');
          }
        },
      ),

    );
  }
}
