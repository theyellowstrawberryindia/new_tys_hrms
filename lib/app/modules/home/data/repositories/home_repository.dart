/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 5:42 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 5:42 pm
 *
 */

import 'dart:io';
import '../../../../data/network/api_client.dart';
import '../../../../data/network/api_endpoints.dart';
import '../models/office_location.dart';

class HomeRepository {
  HomeRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.client;

  final ApiClient _apiClient;

  Future<OfficeLocation> getOffice() async {
    final response = await _apiClient
        .get(APIEndpoints.getOffice)
        .timeout(const Duration(seconds: 10));
    return OfficeLocation.fromResponse(response);
  }

  /// GET USER
  Future<dynamic> getUser() async {
    try {
      final response = await _apiClient.get(APIEndpoints.getUser);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Create Attendance
  Future<dynamic> createAttendance(Map<String, String> body, File? file) async {
    try {
      Map<String, String> files = {"photo": file?.path ?? ""};
      final response = await _apiClient.multipart(
        APIEndpoints.userAttendance,
        body: body,
        files: files,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// GET USER
  Future<dynamic> getTodaysAttendance() async {
    try {
      final response = await _apiClient.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Post token
  Future<dynamic> postToken(Map<String, String> body) async {
    try {
      final response = await _apiClient.post(APIEndpoints.postToken, body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
