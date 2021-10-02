import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final PageController _pageController = PageController(
    ///TO-DO
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, satate) {},
        builder: (context, state) {
          NewsCubit cubit = NewsCubit.get(context);
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.newsChangeBottomNavBar(index);
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    cubit.currentIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.business_center_outlined),
                  label: 'Business',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_basketball),
                  label: 'Sports',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.science_outlined),
                  label: 'Science',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
            body: BlocProvider(
              create: (context) => NewsCubit(),
              child: BlocConsumer<NewsCubit, NewsStates>(
                listener: (context, satate) {},
                builder: (context, state) => PageView(
                  onPageChanged: (index) {
                    cubit.newsChangeBottomNavBar(index);
                  },
                  controller: _pageController,
                  children: cubit.pages,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
