/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 11:36 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 11:36 am
 *
 */

import '../../core/core.dart';

class AuthRepository {

  Future<dynamic> login(dynamic body) async {
    try {
      final response = await ApiClient.client.post(APIEndpoints.login, body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

}

