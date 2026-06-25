/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:38 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:38 pm
 *
 */

import 'package:hrms_ys/app/data/controllers/attendance_controller.dart';
import '../../packages.dart';

class AttendanceBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<AttendanceController>(
          () => AttendanceController(),
    );
  }
}

