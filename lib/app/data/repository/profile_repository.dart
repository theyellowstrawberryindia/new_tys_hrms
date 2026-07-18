/*
 *  Created by Yellow Strawberry LLP on 04/06/26, 12:57 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 04/06/26, 12:57 pm
 *
 */

import 'dart:io';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProfileRepository {


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


  Future<dynamic> updateBank(
      Map<String, String> body, {
        File? panCardImageFile,
        File? aadharCardImageFile,
      }) async {
    try {
      final files = <String, String>{};

      if (panCardImageFile != null) {
        files["pan_img"] = panCardImageFile.path;
      }

      if (aadharCardImageFile != null) {
        files["aadhar_img"] = aadharCardImageFile.path;
      }
      body["_method"] = "PUT";
      return await ApiClient.client.multipart(
        APIEndpoints.editBank,
        body: body,
        files: files,
        httpMethod: HttpMethod.post,
      );
    } catch (e) {
      return Future.error(e);
    }



  }  Future<dynamic> updateFamily(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getTodaysAttendance);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

}