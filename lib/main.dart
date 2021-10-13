import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'bloc_observer.dart';
import 'layout/layout_screen.dart';
import 'shared/network/remote/dio_helper.dart';

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  // var dio = Dio();
  // final response = await dio.get('https://google.com/');
  // print(response.data);
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
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      colorScheme: ColorScheme.light(
        secondary: Colors.white,
      ),
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme(),
      appBarTheme: appBarTheme(),
    );
  }

  TextTheme textTheme() {
    double fontSize = 43;
    String family = 'serif';
    double lineSpacing = 1.2;
    return TextTheme(
      bodyText2: TextStyle(fontSize: 17, color: Colors.grey[800]),
      headline1: TextStyle(
          fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
      headline2: TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        // fontFamily: 'Yanone Kaffeesatz',
      ),
      //for article title in the bottom sheet
      caption: TextStyle(
        height: lineSpacing,
        fontSize: fontSize,
        fontFamily: family,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.black,
      ),
      headline3: TextStyle(
        height: lineSpacing,
        fontFamily: family,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyText1: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 35,
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
