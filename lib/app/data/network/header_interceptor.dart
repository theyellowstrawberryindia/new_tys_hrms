/*
 *  Created by Deepak Gupta on 07/10/25, 12:33 pm
 *  Copyright (c) 2025 . All rights reserved.
 */

// Dart imports:
import 'dart:developer' show log;
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:hrms_ys/app/data/bindings/auth_binding.dart';
import 'package:hrms_ys/app/packages.dart';
import 'package:hrms_ys/app/presentation/screens/auth/auth_screen.dart';

import '../../core/utils/app_storage.dart';


bool isUnauthorized = false;
bool _isHandling401 = false;

class HeaderInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final head = _headers;
    options.headers.addAll(head);
    log("REQUEST URL: ${options.uri}");
    log("TOKEN: ${options.headers[HttpHeaders.authorizationHeader]}");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final path = err.response?.realUri.path ?? '';

    //if user only at login screen.
    if (path.contains('/login')) {
      return handler.next(err);
    }


    if (err.response?.statusCode == 401) {
      _isHandling401 = true;
      AppStorage.instance.clearAll();
      Get.deleteAll(force: true);

      Future.delayed(const Duration(seconds: 1), () {
        _isHandling401 = false;
        Get.offAll(() => AuthScreen(), binding: AuthBinding());

      });
    }

    return handler.next(err);
  }

  Map<String, String> get _headers {
    Map<String, String> map = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final token = AppStorage.instance.valueFor(StorageKey.accessToken);

    if (token != null && token.toString().isNotEmpty) {
      map[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return map;
  }
}
