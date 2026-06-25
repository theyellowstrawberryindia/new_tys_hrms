/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 11:37 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 11:36 am
 *
 */

// Project imports:
import '../controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(),fenix: true);
  }
}
