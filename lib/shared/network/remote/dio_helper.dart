import 'dart:isolate';

import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio();
  }

  static Future<Response?> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return dio == null
        ? (null)
        : await dio!
            .get(
            url,
            queryParameters: query,
          )
            .catchError((e) {
            print('there is an error "getData" : ${e.toString()}');
          });
  }
}
