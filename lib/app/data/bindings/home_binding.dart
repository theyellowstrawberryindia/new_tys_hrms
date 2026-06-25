/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:33 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:33 pm
 *
 */

import '../../packages.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}
