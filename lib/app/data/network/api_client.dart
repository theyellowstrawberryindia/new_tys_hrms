// Dart imports:

import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../core/configs/app_configs.dart';
import 'header_interceptor.dart';
import 'logging_interceptor.dart';

enum HttpMethod{post,put,get,delete}

class ApiClient {

  final _dio = Dio();


  ApiClient._() {
    _dio.interceptors.add(HeaderInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  static final ApiClient _client = ApiClient._();

  static ApiClient get client => _client;


  final BaseOptions _baseOptions = BaseOptions(
      baseUrl: AppConfig.baseURL,
      responseType: ResponseType.json);

  /// Fetches data from the specified [endpoint].
  ///
  /// This method performs a GET request to the given [endpoint].
  /// Optional [query] parameters can be provided to customize the request.
  ///
  /// Returns a [Future] that completes with the response data if the request
  /// is successful (status code 200 or 201).
  ///
  /// If the request fails or returns an error status code, the [Future]
  /// completes with an error. Specifically, if the server returns an error
  /// message in the response body under the 'message' key, that message
  /// will be used as the error. Otherwise, a generic error is thrown.
  ///
  /// Throws:
  ///   - An error if the network request fails.
  ///   - The error message from the server response if available.
  ///   - A generic error for other error scenarios.
  Future<dynamic> get(String endpoint, {Map<String, dynamic> query = const {}}) async {
    try {
      _dio.options = _baseOptions;
      final response = await _dio.get(endpoint, queryParameters: query);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Sends data to the specified [endpoint] using a POST request.
  ///
  /// The [body] of the request is JSON encoded before sending.
  ///
  /// Returns a [Future] that completes with the response data if the request
  /// is successful (status code 200 or 201).
  ///
  /// If the request fails or returns an error status code, the [Future]
  /// completes with an error. Specifically, if the server returns an error
  /// message in the response body under the 'message' key, that message
  /// will be used as the error. Otherwise, a generic error is thrown.
  ///
  /// Throws:
  ///   - An error if the network request fails or if JSON encoding of the [body] fails.
  ///   - The error message from the server response if available.
  ///   - A generic error for other error scenarios.
  Future<dynamic> post(String endpoint, dynamic body,) async {
    try {
      _dio.options = _baseOptions;
      final response = await _dio.post(endpoint, data: jsonEncode(body));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Sends data to the specified [endpoint] using a PUT request.
  ///
  /// The [body] of the request is JSON encoded before sending.
  ///
  /// Returns a [Future] that completes with the response data if the request
  /// is successful (status code 200 or 201).
  ///
  /// If the request fails or returns an error status code, the [Future]
  /// completes with an error. Specifically, if the server returns an error
  /// message in the response body under the 'message' key, that message
  /// will be used as the error. Otherwise, a generic error is thrown.
  ///
  /// Throws:
  ///   - An error if the network request fails or if JSON encoding of the [body] fails.
  ///   - The error message from the server response if available.
  ///   - A generic error for other error scenarios.
  Future<dynamic> put(String endpoint, dynamic body,) async {
    try {
      _dio.options = _baseOptions;
      final response = await _dio.put(endpoint, data: jsonEncode(body));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }


  /// Sends data to the specified [endpoint] using a DELETE request.
  ///
  /// The [body] of the request is JSON encoded before sending.
  ///
  /// Returns a [Future] that completes with the response data if the request
  /// is successful (status code 200 or 201).
  ///
  /// If the request fails or returns an error status code, the [Future]
  /// completes with an error. Specifically, if the server returns an error
  /// message in the response body under the 'message' key, that message
  /// will be used as the error. Otherwise, a generic error is thrown.
  ///
  /// Throws:
  ///   - An error if the network request fails or if JSON encoding of the [body] fails.
  ///   - The error message from the server response if available.
  ///   - A generic error for other error scenarios.
  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    try {
      _dio.options = _baseOptions;
      final response = await _dio.delete(endpoint, data: body != null ? jsonEncode(body) : null);
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Sends a multipart request to the specified endpoint.
  ///
  /// This method is typically used for uploading files.
  /// Args:
  ///   [endpoint]: The API endpoint to send the request to.
  ///   [body]: (Optional) A map of string key-value pairs to be sent as form data. Defaults to an empty map.
  ///   [files]: (Optional) A map of string key-value pairs where the key is the field name where the key is the field name
  ///          and the value is the file path. Defaults to an empty map.
  ///
  /// Returns:
  ///   A Future that completes with the response data if the request is successful (status code 200 or 201).
  ///   Otherwise, it completes with an error containing the error message from the response.
  ///
  /// Throws:
  ///   Catches any exceptions during the request and handles them using the `_handleError` method.
  Future<dynamic> multipart(
    String endpoint, {
    Map<String, String> body = const {},
    Map<String, String> files = const {},
    HttpMethod httpMethod = HttpMethod.post, File? file,
  }) async {
    try {
      Map<String, dynamic> request = {};

      if (body.isNotEmpty) request.addAll(body);

      if (files.isNotEmpty) {
        for (MapEntry element in files.entries) {
          request[element.key] = await MultipartFile.fromFile(
            element.value,
            filename: element.value.toString().split("/").last,
          );
        }
      }

      var form = FormData.fromMap(request);
      _dio.options = _baseOptions;

      var method = 'POST';
      if(httpMethod == HttpMethod.put){
        method = 'PUT';
      }

      final response = await _dio.request(endpoint, data: form,options: Options(method: method));
      return response.data;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Uint8List> download(String endpoint,) async {
    _dio.options = _baseOptions;
    _dio.options.responseType = ResponseType.bytes;

    try {
      final response = await _dio.get(endpoint);

      // Check if response is successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Uint8List) {
          return response.data;
        }

        if (response.data is List<int>) {
          return Uint8List.fromList(response.data);
        }

        throw Exception('Invalid download response type: ${response.data.runtimeType}');
      }

      throw Exception('Download failed with status: ${response.statusCode}');

    } on DioException catch (e) {
      log('DioException in download: ${e.type}, Status: ${e.response?.statusCode}');

      final data = e.response?.data;

      // Connection errors
      if (e.type == DioExceptionType.connectionError) {
        throw Exception("No internet connection");
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout");
      }

      // Handle error responses that came as bytes (JSON)
      if (data is Uint8List || data is List<int>) {
        try {
          final bytes = data is Uint8List ? data : Uint8List.fromList(data);
          final jsonString = utf8.decode(bytes);
          final errorResponse = jsonDecode(jsonString);

          log('Error response parsed: $errorResponse');

          String errorMessage = errorResponse['error'] ??
              errorResponse['message'] ??
              'Download failed';

          // Add status code for context
          if (e.response?.statusCode != null) {
            errorMessage = '[${ e.response!.statusCode}] $errorMessage';
          }

          throw Exception(errorMessage);
        } catch (parseError) {
          log('Failed to parse error response: $parseError');
          throw Exception('Download failed: Unable to parse server response');
        }
      }

      // Handle other error formats
      if (data is Map) {
        final message = data['error'] ?? data['message'] ?? 'Download failed';
        throw Exception(message);
      }

      throw Exception('Download failed: ${e.message ?? "Unknown error"}');

    } catch (e) {
      log('Unexpected error in download: $e');
      rethrow;
    }
  }
  /// Checks if the device is connected to the internet.
  ///
  /// This function attempts to resolve the IP address of "google.com".
  /// If the lookup is successful and returns at least one valid IP address,
  /// it's assumed that the device has an internet connection.
  ///
  /// Returns `true` if a connection to "google.com" can be established,
  /// `false` otherwise
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<dynamic> _handleError(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (e.type == DioExceptionType.connectionError) {
        return Future.error("Looks like you are not connected to internet.");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return Future.error("Server not reachable yet this moment");
      }

      if (data is Uint8List) {
        final temp = jsonDecode(utf8.decode(data));
        return Future.error(temp['message'] ?? temp['error'] ?? "Something went wrong");
      }
      String message = _parseData(data);
      switch (e.response?.statusCode) {
        case 400:
          return Future.error(message);
        case 401:
          return Future.error(message);
        default:
          return Future.error(message);
      }
    } else {
      return Future.error("Something went wrong");
    }
  }


  String _parseData(dynamic response) {
    try{
      String message = response['error'] ?? response['message'] ?? 'Something went wrong';
      return message;
    }catch(e){
      return 'Something went wrong';
    }
  }

}
