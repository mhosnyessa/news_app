import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..newsGetData(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (BuildContext context, NewsStates state) {
          NewsCubit cubit = NewsCubit.get(context);
          return Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: () {
              cubit.newsGetData();
            }),
            appBar: AppBar(
              actions: const [
                Icon(
                  Icons.search,
                ),
                SizedBox(width: 10),
              ],
              title: Text(
                '${cubit.titles[cubit.currentIndex]}',
              ),
            ),
            body: PageView(
              children: cubit.pages,
              controller: cubit.pageController,
              onPageChanged: (index) => cubit.newsChangeBottomNavBar(index),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: navigationItems,
              backgroundColor: Colors.white,
              elevation: 20.0,
              currentIndex: cubit.currentIndex,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                cubit.newsChangeBottomNavBar(index);
              },
            ),
          );
        },
      ),
    );
  }

  List<BottomNavigationBarItem> get navigationItems {
    return const [
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
    ];
  }
}
