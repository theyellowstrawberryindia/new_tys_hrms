/*
 *  Created by Yellow Strawberry LLP on 03/06/26, 4:10 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 03/06/26, 4:10 pm
 *
 */

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ApplyLeaveRepository {

  /// GET LEAVE STATUS
  Future<dynamic> getLeaveStatus() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getLeaveStatus);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// REQUEST LEAVE
  Future<dynamic> applyLeave(dynamic body) async {
    try {
      final response = await ApiClient.client.post(APIEndpoints.applyLeave, body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}