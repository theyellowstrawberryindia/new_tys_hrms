/*
 *  Created by Yellow Strawberry LLP on 02/06/26, 5:57 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 02/06/26, 5:57 pm
 *
 */


import 'package:hrms_ys/app/data/controllers/regularize_controller.dart';
import '../../packages.dart';

class RegularizeBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<RegularizeController>(() => RegularizeController(),);
  }
}


