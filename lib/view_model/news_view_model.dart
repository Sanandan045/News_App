import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channels_headlines.dart';
import 'package:news_app/repository/news_repo.dart';

class NewsViewModel {
  final _repo = NewsRepository();
  Future<NewsChannelsHeadlinesModel> fetchNewsChannleHeadlinesApi(
      String channelName) async {
    final response = await _repo.fetchNewsChannleHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String categories) async {
    final response1 = await _repo.fetchCategoriesNewsApi(categories);
    return response1;
  }
}
