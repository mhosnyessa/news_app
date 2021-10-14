import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';

ListView buildNewsList(Response news, NewsCubit cubit) {
  return ListView.separated(
      itemBuilder: (ctx, i) {
        return buildSingleNewsCard(context: ctx, index: i, news: news);
      },
      separatorBuilder: (_, i) => const Divider(
            height: 4,
            thickness: 3,
            indent: 10,
            endIndent: 10,
          ),
      itemCount: news.data['articles'].length);
}

Widget buildSingleNewsCard({
  required BuildContext context,
  required int index,
  required Response news,
}) {
  return BlocConsumer<NewsCubit, NewsStates>(
    listener: (_, i) {},
    builder: (ctx, state) {
      NewsCubit cubit = NewsCubit.get(ctx);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            cubit.newsOpenArticleBottomSheet(context, index);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImageNewsCard(news.data['articles'][index]['urlToImage']),
              const SizedBox(width: 10),
              InfoNewsCard(
                title: news.data['articles'][index]['title'],
                date: news.data['articles'][index]['publishedAt'],
              )
            ],
          ),
        ),
      );
    },
  );
}

ClipRRect buildImageNewsCard(
  String? url,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: 150,
      height: 100,
      child: Image.network(
        url ??
            'https://previews.123rf.com/images/maxkabakov/maxkabakov1509/maxkabakov150900307/44476813-news-concept-pixelated-text-business-news-on-newspaper-background.jpg',
        fit: BoxFit.cover,
      ),
    ),
  );
}

class InfoNewsCard extends StatelessWidget {
  final String title;
  final String date;
  const InfoNewsCard({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(
            height: 5,
          ),
          Text(date, style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }
}

class BottomArticleContent extends StatelessWidget {
  final dynamic news;
  final int index;
  BottomArticleContent({
    required this.news,
    required this.index,
  });
  @override
  init() {}
  // BottomArticleContent(Color color, double height, int index, double width,
  // BuildContext context);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double kHeight = height * 0.75;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: kHeight,
      child: Stack(
        children: [
          Positioned(
            top: 20,
            child: ImageBackgroundBottomSheet(
                width: width, kHeight: kHeight, news: news, index: index),
          ),
          Positioned(
            right: 40,
            child: ElevatedButton(
              onPressed: () =>
                  launchURL(news.data['articles'][index]['url'] ?? ''),
              child: Row(
                children: [
                  Text(
                    'source',
                    style: Theme.of(context).textTheme.button,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.launch,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 0,
            child: ArticleTextBottomSheet(
              kHeight: kHeight,
              width: width,
              index: index,
              news: news,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageBackgroundBottomSheet extends StatelessWidget {
  const ImageBackgroundBottomSheet({
    Key? key,
    required this.width,
    required this.kHeight,
    required this.news,
    required this.index,
  }) : super(key: key);

  final double width;
  final double kHeight;
  final Response news;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(width * 0.2),
      ),
      child: Container(
        height: kHeight,
        width: width,
        child: Stack(
          children: [
            SizedBox(
              height: kHeight,
              width: width,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Image.network(
                  news.data['articles'][index]['urlToImage'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: kHeight,
              width: width,
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
  }
}

class ArticleTextBottomSheet extends StatelessWidget {
  const ArticleTextBottomSheet({
    Key? key,
    required this.kHeight,
    required this.width,
    required this.news,
    required this.index,
  }) : super(key: key);

  final double kHeight;
  final double width;
  final Response news;
  final int index;

  @override
  Widget build(BuildContext context) {
    String title = news.data['articles'][index]['title'];
    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
        left: 28.0,
        right: 28.0,
      ),
      height: kHeight,
      width: width,
      // color: Colors.blue,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Text(
                  '$title',
                  maxLines: 4,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  '$title',
                  maxLines: 4,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            Divider(
              color: Colors.white,
              height: 15,
              thickness: 4,
            ),
            Stack(
              children: [
                buildContentTextBottomSheet(context),
                buildContentTextBottomSheet(context, isStroke: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RichText buildContentTextBottomSheet(BuildContext context,
      {bool isStroke = false}) {
    return RichText(
      text: TextSpan(
        style: !isStroke
            ? Theme.of(context).textTheme.headline2
            : Theme.of(context).textTheme.headline2!.copyWith(
                  color: null,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..color = Colors.black
                    ..strokeWidth = 2.0,
                ),
        children: [
          TextSpan(
            text: (news.data['articles'][index]['content'] ??
                    'content not available')
                .toString()
                .replaceAllMapped(RegExp(r'\[\+.+\]'), (match) => ''),
          ),
        ],
      ),
    );
  }
}
