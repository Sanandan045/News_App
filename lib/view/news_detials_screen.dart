import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen extends StatefulWidget {
  String newsImage, newsTitle, newsDate, author, description, content, source;

  NewsDetailsScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.content,
    required this.description,
    required this.source,
  });

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final format = DateFormat('MMMM dd ,yyyy');
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.newsDate);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.newsImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  child: SpinKitFadingCircle(color: Colors.green),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.newsTitle,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.source,
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              Text(
                format.format(dateTime),
                style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(widget.description)
        ]),
      ),
    );
  }
}
