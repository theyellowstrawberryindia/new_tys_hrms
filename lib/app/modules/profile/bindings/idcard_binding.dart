/*
 *  Created by Yellow Strawberry LLP on 22/06/26, 5:06 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 22/06/26, 5:06 pm
 *
 */

import 'package:get/get.dart';

import '../controllers/idcard_controller.dart';

class IDCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IDCardController>(() => IDCardController());
  }
}
