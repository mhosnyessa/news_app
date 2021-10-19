import 'dart:ui';
import 'package:news_app_cubit_and_dio/shared/components.dart';
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
  sports,
  science,
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
  static int initialIndex = 0;

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
    'sports',
    'science',
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

  void newsGetData() async {
    for (int i = 0; i < 3; i++) {
      Map<String, dynamic> query = {
        'apiKey': '9fc4698a58ff407aaba9edb4c4cf7283',
        'category': categories[i],
        'country': 'us',
      };
      print('before get data$i');

      await DioHelper.getData(
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
          news: news![currentIndex],
          index: index,
        );
      },
    );
  }
}

launchURL(String url) async {
  await launch(url).then((value) => null).catchError((e) => print(e.toString));
}
