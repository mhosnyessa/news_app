import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/shared/components.dart';
import 'package:news_app_cubit_and_dio/shared/network/remote/dio_helper.dart';
import 'package:buildcondition/buildcondition.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (ctx, state) {},
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        Response? businessNews = cubit.businessNews;
        return BuildCondition(
          condition: businessNews != null,
          builder: (context) => buildNewsList(businessNews!, cubit),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
