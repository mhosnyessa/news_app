import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'bloc_observer.dart';
import 'layout/layout_screen.dart';
import 'layout/layout_depricated.dart';
import 'layout/page_controller_depricated.dart';
import 'shared/network/remote/dio_helper.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  dioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Layout(),
      theme: themeData(),
    );
  }

  ThemeData themeData() {
    return ThemeData(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      primaryColor: Colors.white,
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme(),
      appBarTheme: appBarTheme(),
    );
  }

  TextTheme textTheme() {
    return TextTheme(
      bodyText2: TextStyle(fontSize: 17, color: Colors.grey[800]),
      bodyText1: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  AppBarTheme appBarTheme() {
    return const AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 27,
      ),
      color: Colors.white,

      elevation: 0.0,
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.white,
      // ),
    );
  }
}
