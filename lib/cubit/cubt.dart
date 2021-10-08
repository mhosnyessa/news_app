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
        return BottomArticleContent(
          news: businessNews,
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
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width * 0.4),
              ),
              child: Container(
                height: kHeight,
                color: Colors.blue,
                child: Image.network(
                  news!.data['articles'][index]['urlToImage'] ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'hello',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   double height = 200;
  //   double width = MediaQuery.of(context).size.width;
  //   Color color = Colors.purple[50] ?? Colors.white;
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(120),
  //               topRight: Radius.circular(25),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   color: color,
  //                   height: height,
  //                   child: Stack(
  //                     children: [
  //                       news!.data['articles'][index]['urlToImage'] == null
  //                           ? Container(
  //                               color: color,
  //                               height: double.infinity,
  //                               width: double.infinity,
  //                             )
  //                           : Container(
  //                               height: height,
  //                               width: width,
  //                               child: Image.network(
  //                                 news!.data['articles'][index]['urlToImage'],
  //                                 errorBuilder: (context, _, s) {
  //                                   return Container(
  //                                     height: height,
  //                                     width: width,
  //                                     color: Colors.grey,
  //                                     child: Center(
  //                                         child: Text('image not available')),
  //                                   );
  //                                 },
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                       Positioned(
  //                         child: Container(
  //                           height: height,
  //                           width: width,
  //                           child: Expanded(
  //                             child: Column(
  //                               mainAxisSize: MainAxisSize.max,
  //                               children: [
  //                                 Spacer(),
  //                                 Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 20.0, vertical: 0.5),
  //                                   child: Text(
  //                                     news!.data['articles'][index]['title'],
  //                                     maxLines: 4,
  //                                     textAlign: TextAlign.left,
  //                                     style:
  //                                         Theme.of(context).textTheme.headline1,
  //                                     // style: TextStyle(
  //                                     //   shadows: [
  //                                     //     Shadow(
  //                                     //       color: Colors.black12,
  //                                     //       blurRadius: 0.1,
  //                                     //       // offset:
  //                                     //       //     Offset.fromDirection(0.2, 0.2),
  //                                     //     ),
  //                                     //   ],
  //                                     //   color: Colors.black,
  //                                     //   overflow: TextOverflow.ellipsis,
  //                                     //   fontSize: 30,
  //                                     //   fontWeight: FontWeight.bold,
  //                                     // ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               colors: [
  //                                 color,
  //                                 Colors.transparent,
  //                               ],
  //                               end: Alignment.topCenter,
  //                               begin: Alignment(0.0, 0.4),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Positioned(
  //             top: -30,
  //             child: ElevatedButton(
  //               onPressed: () {},
  //               child: RichText(
  //                 text: TextSpan(children: [
  //                   TextSpan(
  //                     recognizer: TapGestureRecognizer()
  //                       ..onTap = () => launchURL(
  //                           news!.data['articles'][index]['url'] ?? ''),
  //                     text: 'Read more.',
  //                     style: Theme.of(context).textTheme.headline2!.copyWith(
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).colorScheme.secondary,
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                   ),
  //                   WidgetSpan(
  //                     child: Icon(
  //                       Icons.launch,
  //                       color: Theme.of(context).colorScheme.secondary,
  //                     ),
  //                   ),
  //                 ]),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       Container(
  //         height: 200,
  //         width: double.infinity,
  //         color: color,
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: RichText(
  //           text: TextSpan(
  //             style: Theme.of(context).textTheme.headline2,
  //             children: [
  //               TextSpan(
  //                 text: (news!.data['articles'][index]['content'] ??
  //                         'content not available')
  //                     .toString()
  //                     .replaceAllMapped(RegExp(r'\[\+.+\]'), (match) => ''),
  //               ),
  //               TextSpan(
  //                 children: [
  //                   TextSpan(
  //                     recognizer: TapGestureRecognizer()
  //                       ..onTap = () => launchURL(
  //                           news!.data['articles'][index]['url'] ?? ''),
  //                     text: 'Read more.',
  //                     style: Theme.of(context).textTheme.headline2!.copyWith(
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).primaryColor,
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                   ),
  //                   WidgetSpan(
  //                     child: Icon(
  //                       Icons.launch,
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
