import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';

Widget buildNewsScreen() {
  return BlocConsumer<NewsCubit, NewsStates>(
    listener: (ctx, state) {},
    builder: (context, state) {
      NewsCubit cubit = NewsCubit.get(context);
      return const Center(
        child: Text(
          'Business Page',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    },
  );
}
