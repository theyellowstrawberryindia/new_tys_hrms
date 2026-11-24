/*
 *  Created by Yellow Strawberry LLP on 04/06/26, 12:57 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 04/06/26, 12:57 pm
 *
 */

import 'dart:io';

import '../../../../data/network/api_client.dart';
import '../../../../data/network/api_endpoints.dart';

class ProfileRepository {
  ProfileRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.client;

  final ApiClient _apiClient;

  Future<dynamic> changeProfilePhoto(Map<String, String> body, File? file) async {
    try {

      Map<String, String> files = {};

      if(file != null){
        files = {
          "src":file.path ,
        };
      }
      final response = await ApiClient.client.multipart(APIEndpoints.profilePicture,
          body: body, files: files);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }



  Future<dynamic> updateContact(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateProfessional(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updatePersonal(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<Map<String, dynamic>> updateBank(
    Map<String, String> body, {
    File? panCardImageFile,
    File? aadharCardImageFile,
  }) async {
    final response = await _apiClient.multipart(
      APIEndpoints.editBank,
      body: {...body, '_method': 'PUT'},
      files: {
        if (panCardImageFile != null) 'pan_img': panCardImageFile.path,
        if (aadharCardImageFile != null) 'aadhar_img': aadharCardImageFile.path,
      },
      sensitive: true,
    );
    if (response is Map<String, dynamic>) return response;
    throw const FormatException('Unexpected bank details response');
  }

  Future<dynamic> updateFamily(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

}
