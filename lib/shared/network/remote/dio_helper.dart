import 'dart:isolate';

import 'package:dio/dio.dart';

class dioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }
}
