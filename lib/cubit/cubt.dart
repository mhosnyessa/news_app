import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/modules/business_screen/business_screen.dart';
import 'package:news_app_cubit_and_dio/modules/science_screen/science_screen.dart';
import 'package:news_app_cubit_and_dio/modules/settings_screen/settings_screen.dart';
import 'package:news_app_cubit_and_dio/modules/sports_screen/sports_screen.dart';
import 'package:dio/dio.dart';
import '../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  ///these are for the BottomNavigationBar
  List<Widget> pages = [
    const businessScreen(),
    SportsScreen(),
    const ScienceScreen(),
    const SettingsScreen(),
  ];
  List<String> titles = [
    'Business',
    'Sports',
    'Science',
    'Settings',
  ];
  int currentIndex = 0;
  PageController pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );

  ///
  ///
  // TO:DO
  ///
  ///
  Response<dynamic>? businessNews;
  Map<String, dynamic> query = {
    'country': 'us',
    'category': 'business',
    'apiKey': '9fc4698a58ff407aaba9edb4c4cf7283'
  };

  ///
  ///
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
    DioHelper.getData(
            url:
                'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=9fc4698a58ff407aaba9edb4c4cf7283',
            query: query)
        .then((value) {
      businessNews = value;
      print('business news ' + businessNews.toString());
      emit(NewsFetchedDataState());
    });
  }

  void newsOpenArticleBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double height = 300;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(120),
                topRight: Radius.circular(25),
              ),
              child: Container(
                height: height * 2,
                width: double.infinity,
                color: Colors.green,
                child: Container(
                  color: Colors.red,
                  height: height,
                  child: Stack(
                    children: [
                      businessNews!.data['articles'][index]['urlToImage'] ==
                              null
                          ? Container(
                              color: Colors.red,
                              height: double.infinity,
                              width: double.infinity,
                            )
                          : Container(
                              height: height,
                              child: Image.network(
                                businessNews!.data['articles'][index]
                                    ['urlToImage'],
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                          bottom: 0,
                          child: Container(
                            height: height,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                end: Alignment.topCenter,
                                begin: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(businessNews!.data['articles'][index]
                                    ['title']),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
