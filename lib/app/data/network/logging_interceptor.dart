/*
 *  Created by Deepak Gupta on 07/10/25, 12:38 pm
 *  Copyright (c) 2025 . All rights reserved.
 */

// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Package imports:
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor{
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('REQUEST =>  ${response.requestOptions.data}');
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}');
    log("DATA => ${jsonEncode(response.data)}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}');
    log('REQUEST: ${err.response?.requestOptions.data}');
    log("DATA => ${jsonEncode(err.response?.data)}");
    super.onError(err, handler);
  }
}
