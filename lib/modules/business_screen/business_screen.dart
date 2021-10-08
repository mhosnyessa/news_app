import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/shared/components.dart';
import 'package:news_app_cubit_and_dio/shared/network/remote/dio_helper.dart';
import 'package:buildcondition/buildcondition.dart';

class businessScreen extends StatelessWidget {
  const businessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NewsCubit cubit = NewsCubit.get(context);
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (ctx, state) {
        // if (state is! NewsFetchedDataState) {
        //   cubit.newsGetData();
        // }
      },
      builder: (context, state) {
        // return buildNewsCard();
        // cubit.newsGetData();
        return BuildCondition(
          condition: cubit.businessNews != null,
          // builder: (context) => BuildNewsCard(),
          builder: (context) => ListView.separated(
              itemBuilder: (ctx, i) {
                return BuildNewsCard(i);
              },
              separatorBuilder: (_, i) => Divider(),
              itemCount: cubit.businessNews!.data['articles'].length),

          // ListView.builder
          //
          // (
          //     cacheExtent: 50,
          //     itemBuilder: (ctx, i) {
          //       sleep(Duration(milliseconds: 400));
          //       return BuildNewsCard(i);
          //     }),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget BuildNewsCard(
    int i,
  ) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, states) {},
      builder: (context, states) {
        NewsCubit cubit = NewsCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              cubit.newsOpenArticleBottomSheet(context, i);
            },
            onLongPress: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageNewsCard(
                    cubit.businessNews!.data['articles'][i]['urlToImage']),
                SizedBox(width: 10),
                InfoNewsCard(
                  title: cubit.businessNews!.data['articles'][i]['title'],
                  date: cubit.businessNews!.data['articles'][i]['publishedAt'],
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
