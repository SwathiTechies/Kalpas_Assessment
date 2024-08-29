import 'package:flutter/material.dart';
import '../Model/news_model.dart';
import 'new_list_screen.dart';
import 'news_fav_screen.dart';

class NewsTabScreen extends StatefulWidget {
  const NewsTabScreen({super.key});

  @override
  State<NewsTabScreen> createState() => _NewsTabScreenState();
}

class _NewsTabScreenState extends State<NewsTabScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Article> _favorites = [];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      // Handle tab change logic here
      _tabController = TabController(length: 2, vsync: this);
      print('Tab changed to ${_tabController.index}');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          padding: EdgeInsets.only(bottom: 20),
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          splashFactory: NoSplash.splashFactory,
          splashBorderRadius: BorderRadius.zero,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list, size: 43,),
                  SizedBox(width: 8), // Space between icon and text
                  Text('News', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 43, color: Colors.red,),
                  SizedBox(width: 8), // Space between icon and text
                  Text('Favs', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics:  NeverScrollableScrollPhysics(),
        children: [
          Center(child: NewsListScreen()),
          Center(child: FavoritesScreen()),
        ],
      ),
    );
  }
}
