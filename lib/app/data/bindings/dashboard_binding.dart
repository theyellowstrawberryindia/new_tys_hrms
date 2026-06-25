/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:00 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:00 pm
 *
 */


// Project imports:
import 'package:hrms_ys/app/data/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(),fenix: true);
  }
}

