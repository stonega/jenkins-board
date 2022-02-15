import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'package:jenkins_board/storage/hive_box.dart';

class ApiService {
  static final Dio dio = Dio(BaseOptions(
    receiveTimeout: 30000,
    connectTimeout: 30000,
  ));

  // add interceptors
  static init() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
      return handler.next(options);
    }, onResponse: (Response response, handler) {
      developer.log('Neteork request');
      return handler.next(response);
    }, onError: (DioError e, handler) {
      handleError(e);
      return handler.next(e);
    }));
    final authCode = HiveBox.getToken();
    final baseUrl = HiveBox.getBaseUrl();
    setToken(authCode);
    setBaseUrl(baseUrl);
  }

  // error handle
  static void handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
        developer.log("Connect timeout", name: 'Network error');
        break;
      case DioErrorType.receiveTimeout:
        developer.log("Receive timeout", name: 'Netwrok error');
        break;
      case DioErrorType.response:
        developer.log("Network exception", name: 'Network error');
        break;
      case DioErrorType.cancel:
        developer.log("Request cancelled", name: 'Network error');
        break;
      default:
        developer.log("Unknown error", name: 'Network error');
        break;
    }
  }

  static Future get(String url, [Map<String, dynamic>? params]) async {
    Response response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  static Future post(String url,
      [Map<String, dynamic>? params, String? token]) async {
    var response = await dio.post(url, queryParameters: params);
    return response.data;
  }

  static Future postHeader(String url,
      [Map<String, dynamic>? data, String? token]) async {
    var response = await dio.post(url, data: data);
    return response.headers;
  }

  static Future delete(String url,
      [Map<String, dynamic>? params, String? token]) async {
    var response = await dio.delete(url, queryParameters: params);
    return response.data;
  }

  static Future postJson(String url,
      [Map<String, dynamic>? data, String? token]) async {
    var response = await dio.post(url, data: data);
    return response.data;
  }

  static Future deleteJson(String url,
      [Map<String, dynamic>? data, String? token]) async {
    var response = await dio.delete(url, data: data);
    return response.data;
  }

  static Future put(String url,
      [Map<String, dynamic>? data, String? token]) async {
    var response = await dio.put(url, queryParameters: data);
    return response.data;
  }

  static Future putJson(String url,
      [Map<String, dynamic>? data, String? token]) async {
    var response = await dio.put(url, data: data);
    return response.data;
  }

  static Future downloadFile(urlPath, savePath) async {
    Response? response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (count, total) {
        developer.log("$count $total", name: 'Download progress');
      });
    } on DioError catch (e) {
      handleError(e);
    }
    return response?.data;
  }

  static setToken(String authCode) {
    if (authCode != '') {
      dio.options.headers["Authorization"] = "Basic $authCode";
    } else {
      dio.options.headers.remove('Authorization');
    }
  }

  static setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }
}
