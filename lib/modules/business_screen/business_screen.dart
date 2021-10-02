import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_cubit_and_dio/cubit/cubt.dart';
import 'package:news_app_cubit_and_dio/cubit/states.dart';
import 'package:news_app_cubit_and_dio/shared/components.dart';
import 'package:news_app_cubit_and_dio/shared/network/remote/dio_helper.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (ctx, state) {},
      builder: (context, state) {
        NewsCubit cubit = NewsCubit.get(context);
        Map<String, dynamic> query = {
          'country': 'us',
          'api-key': '9fc4698a58ff407aaba9edb4c4cf7283'
        };
        var businessNews =
            dioHelper.getData(url: 'v2/top-headlines', query: query);
        return buildNewsCard();
      },
    );
  }

  Padding buildNewsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [buildImageNewsCard(), SizedBox(width: 10), InfoNewsCard()],
      ),
    );
  }

  ClipRRect buildImageNewsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 150,
        height: 100,
        child: Image.network(
          'https://cdn.cnn.com/cnnnext/dam/assets/211001202056-j-16-fighter-file-super-tease.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class InfoNewsCard extends StatelessWidget {
  const InfoNewsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Title', style: Theme.of(context).textTheme.bodyText1),
        Text('date', style: Theme.of(context).textTheme.bodyText2),
      ],
    );
  }
}
