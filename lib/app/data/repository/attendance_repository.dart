/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 3:10 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 3:10 pm
 *
 */

import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class AttendanceRepository {

  /// GET ATTENDANCE
  Future<dynamic> getAttendance(dynamic body) async {
    try {
      final response = await ApiClient.client.get(APIEndpoints.getAttendance, query: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }



}