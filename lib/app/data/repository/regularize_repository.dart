/*
 *  Created by Yellow Strawberry LLP on 02/06/26, 5:43 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 02/06/26, 5:43 pm
 *
 */

import 'dart:io';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class RegularizeRepository {

  ///SUBMIT REGULARIZATION
  Future<dynamic> submitRegularization(Map<String, String> body, File? file) async {
    try {

      Map<String, String> files = {};

      if(file != null){
        files = {
          "image":file.path ,
        };
      }

      final response = await ApiClient.client.multipart(APIEndpoints.submitRegularization, body: body, files: files);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}