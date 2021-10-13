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
