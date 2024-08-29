import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/news_model.dart';

Future<NewsListModel?> fetchData() async {
  try {
    final res = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=1d1ce054978744efb4a2608e39d0b1c8'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      return NewsListModel.fromJson(json);
    } else {
      throw Exception('Failed to load news data');
    }
  }
  catch(e){
  print('Error: $e');
  return null;
  }

}
