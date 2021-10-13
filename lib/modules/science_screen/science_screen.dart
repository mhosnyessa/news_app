import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/shared/components.dart';
import 'package:buildcondition/buildcondition.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (ctx, state) {},
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        Response? scienceNews = cubit.news![NewsEnum.science.index];
        return BuildCondition(
          condition: scienceNews != null,
          builder: (context) => buildNewsList(scienceNews!, cubit),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
