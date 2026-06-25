/*
 *  Created by Yellow Strawberry LLP on 03/06/26, 3:26 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 03/06/26, 3:26 pm
 *
 */

import '../../packages.dart';
import '../controllers/apply_leave_controller.dart';

class ApplyLeaveBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<ApplyLeaveController>(
          () => ApplyLeaveController(),
    );
  }
}