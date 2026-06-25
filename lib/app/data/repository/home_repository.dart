/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 5:42 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 5:42 pm
 *
 */

import 'dart:io';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class HomeRepository {


  /// GET USER
  Future<dynamic> getUser() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getUser);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  ///Create Attendance
  Future<dynamic> createAttendance(Map<String, String> body, File? file) async {
    try {
      Map<String, String> files = {
        "photo":file?.path ?? "",
      };
      final response = await ApiClient.client.multipart(APIEndpoints.userAttendance, body: body, files: files);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  /// GET USER
  Future<dynamic> getTodaysAttendance() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  ///Post token
  Future<dynamic> postToken(Map<String, String> body) async {
    try {
      final response = await ApiClient.client.post(APIEndpoints.postToken, body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}