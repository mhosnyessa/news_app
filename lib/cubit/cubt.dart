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

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  ///these are for the BottomNavigationBar
  List<Widget> pages = [
    const BusinessScreen(),
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
  var response;
  void getData() async {
    try {
      response = await Dio().get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=9fc4698a58ff407aaba9edb4c4cf7283');
      print(response['articles']);
    } catch (e) {
      print("an error occured" + e.toString());
    }
  }

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
}
