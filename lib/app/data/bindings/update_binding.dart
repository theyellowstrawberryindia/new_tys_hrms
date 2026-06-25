/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:39 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:39 pm
 *
 */

import 'package:hrms_ys/app/data/controllers/update_controller.dart';
import '../../packages.dart';

class UpdateBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<UpdateController>(
          () => UpdateController(),
    );
  }
}

