import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannleHeadlinesApi(
      String channelName) async {
    final String url =
        "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=87dac39033a140b78da6cd00aade360a";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception("Error");
    }
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String categories) async {
    final String url =
        "https://newsapi.org/v2/everything?q=$categories&apiKey=87dac39033a140b78da6cd00aade360a";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception("Error");
    }
  }
}
