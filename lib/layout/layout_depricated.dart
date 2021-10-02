import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (BuildContext context, NewsStates state) {},
        builder: (BuildContext context, NewsStates state) {
          NewsCubit cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: FloatingActionButton(onPressed: () {}),
            bottomNavigationBar: BottomNavigationBar(
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
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.newsChangeBottomNavBar(index);
              },
            ),
            body: cubit.pages[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
