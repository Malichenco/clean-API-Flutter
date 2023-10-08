import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

BaseOptions options = BaseOptions(
  baseUrl: 'https://staging.taillz.com/api/v1/',
  connectTimeout: Duration(milliseconds: 1000),
  receiveTimeout: Duration(milliseconds: 1000),
  maxRedirects: 2,
  responseType: ResponseType.json,
);

var _apiDio = Dio(options);

bool isLoading = false;

Dio httpClient() {
  _apiDio.interceptors.add(PrettyDioLogger(
    requestHeader: !kReleaseMode,
    requestBody: !kReleaseMode,
    responseBody: !kReleaseMode,
  ));
  _apiDio.interceptors.add(HeaderInterceptor());
  return _apiDio;
}

Dio httpClientWithHeader(token) {
  _apiDio.interceptors.add(PrettyDioLogger(
    requestHeader: !kReleaseMode,
    requestBody: !kReleaseMode,
    responseBody: !kReleaseMode,
  ));
  String basicAuth = 'Bearer $token';
  _apiDio.options.headers.addAll({
    'Authorization': basicAuth,
  });
  return _apiDio;
}

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _apiDio.interceptors.clear();
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _apiDio.interceptors.clear();
    if (isLoading) {
      isLoading = false;
      // LockOverlay().closeOverlay();
    }
    return super.onError(err, handler);
  }
}
