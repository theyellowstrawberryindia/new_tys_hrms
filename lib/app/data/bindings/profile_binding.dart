/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:38 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:38 pm
 *
 */


import 'package:hrms_ys/app/data/controllers/profile_controller.dart';
import '../../packages.dart';

class ProfileBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<ProfileController>(() => ProfileController(),);
  }
}

