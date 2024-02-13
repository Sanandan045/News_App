import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channels_headlines.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detials_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, aljazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd ,yyyy');
  FilterList? selectedFilter;

  String name = "bbc-news";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoriesScreen()),
              );
            },
            icon: Icon(Icons.category_outlined)),
        title: Text(
          "News",
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedFilter,
            icon: Icon(Icons.filter_alt_outlined),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (FilterList.aljazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              setState(() {
                selectedFilter = item;
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text("BBC News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text("ARY News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aljazeera,
                child: Text("Aljazaeera New"),
              ),
            ],
          )
        ],
      ),
      body: ListView(children: [
        SizedBox(
          height: height * .5,
          width: width,
          child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannleHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(
                    color: Colors.blue,
                    size: 40,
                  );
                }
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetailsScreen(
                                      newsImage: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      newsTitle: snapshot
                                          .data!.articles![index].title
                                          .toString(),
                                      newsDate: snapshot
                                          .data!.articles![index].publishedAt
                                          .toString(),
                                      source: snapshot
                                          .data!.articles![index].source!.name
                                          .toString(),
                                      author: snapshot
                                          .data!.articles![index].author
                                          .toString(),
                                      description: snapshot
                                          .data!.articles![index].description
                                          .toString(),
                                      content: snapshot
                                          .data!.articles![index].content
                                          .toString(),
                                    )),
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * .6,
                                width: width * .9,
                                padding: EdgeInsets.all(7),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: SpinKitFadingCircle(
                                          color: Colors.green),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(15),
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: width * 0.7,
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            )),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tesla News Top Headlines",
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent)),
        ),
        // added one category here

        SizedBox(
          height: 400,
          child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('tesla'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 40,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error occurred: ${snapshot.error}"),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => Container(
                                    child: SpinKitFadingCircle(
                                        color: Colors.green),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .20,

                                  // color: Colors.yellow,
                                  padding: EdgeInsets.only(left: 12),
                                  child: Column(children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black)),
                                    SizedBox(
                                      height: 35,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Source :'),
                                        Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('date :',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black)),
                                        Text(format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black))
                                      ],
                                    )
                                  ]),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                );
              }),
        )
      ]),
    );
  }
}
