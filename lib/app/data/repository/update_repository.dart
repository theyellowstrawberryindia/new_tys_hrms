/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 1:53 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 1:53 pm
 *
 */

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class UpdateRepository {


  /// GET ATTENDANCE
  Future<dynamic> getApprovals() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getApprovals);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<dynamic> getNotifications() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getNotifications);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<dynamic> getHolidays() async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getHolidays);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}