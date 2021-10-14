import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/shared/components.dart';
import 'package:buildcondition/buildcondition.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (ctx, state) {},
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        Response? sportsNews;
        if (cubit.news != null && cubit.news!.length > NewsEnum.sports.index) {
          sportsNews = cubit.news![NewsEnum.sports.index];
        }
        return BuildCondition(
          condition: sportsNews != null,
          builder: (context) => buildNewsList(sportsNews!, cubit),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
