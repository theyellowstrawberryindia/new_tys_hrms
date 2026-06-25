/*
 *  Created by Yellow Strawberry LLP on 21/05/26, 7:00 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 21/05/26, 5:44 pm
 *
 */

import 'dart:developer';

import 'package:flutter/foundation.dart';

class AppUtils {

  AppUtils._();

  static printMessage(String message) {
    if (kDebugMode) {
      log(message);
    }
  }
}