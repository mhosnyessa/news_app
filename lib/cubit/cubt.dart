import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/modules/business_screen/business_screen.dart';
import 'package:news_app_cubit_and_dio/modules/science_screen/science_screen.dart';
import 'package:news_app_cubit_and_dio/modules/settings_screen/settings_screen.dart';
import 'package:news_app_cubit_and_dio/modules/sports_screen/sports_screen.dart';
import 'package:dio/dio.dart';

import '../shared/network/remote/dio_helper.dart';

enum NewsEnum {
  business,
  science,
  sports,
  settings,
}

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  ///these are for the BottomNavigationBar
  List<Widget> pages = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
    const SettingsScreen(),
  ];
  List<String> titles = [
    'Business',
    'Sports',
    'Science',
    'Settings',
  ];
  static int initialIndex = 1;

  int currentIndex = initialIndex;
  PageController pageController = PageController(
    keepPage: true,
    initialPage: initialIndex,
  );

  ///
  ///
  /// getting the news
  List<Response<dynamic>?>? news;
  static List<String> categories = [
    'business',
    'science',
    'sports',
  ];
  void newsChangeBottomNavBar(int index) {
    if (pageController.hasClients) {
      if ((currentIndex - index).abs() > 1) {
        print("${currentIndex - index}");
        pageController.jumpToPage(
          index,
        );
      } else {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      currentIndex = index;
      emit(NewsChangeBottomNavBarState());
    }
  }

  void newsGetData() {
    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> query = {
        'apiKey': '9fc4698a58ff407aaba9edb4c4cf7283',
        'category': categories[i],
        'country': 'us',
      };
      print('before get data$i');
      DioHelper.getData(
              url: 'https://newsapi.org/v2/top-headlines', query: query)
          .then((value) {
        news = news ?? [];
        news!.add(value);
        print('business news ' + news.toString());
        emit(NewsFetchedDataState());
      }).catchError((e) {
        print('business news ' + e.toString());
      });
      print('after get data' + i.toString());
    }
  }

  void newsOpenArticleBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomArticleContent(
          news: news,
          index: index,
        );
      },
    );
  }
}

launchURL(String url) async {
  await launch(url).then((value) => null).catchError((e) => print(e.toString));
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
