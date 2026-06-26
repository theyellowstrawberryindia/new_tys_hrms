/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:00 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:00 pm
 *
 */
import 'package:hrms_ys/app/data/controllers/home_controller.dart';
import 'package:hrms_ys/app/data/controllers/profile_controller.dart';
import 'package:hrms_ys/app/data/controllers/update_controller.dart';

import '../../packages.dart';
import '../../presentation/screens/attendance/attendance_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/update/update_screen.dart';
import '../bindings/attendance_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/update_binding.dart';
import 'attendance_controller.dart';



/// For your HRMS project,
/// (controllers registered once, APIs loaded on demand with a _loaded flag
/// and explicit loadData() methods) is the architecture
/// It fits well with GetX, 'preserves your existing navigation logic,
/// and avoids the complexity of creating and destroying controllers dynamically.

class DashboardController extends GetxController {

  int selectedIndex = 0;

  final List<Widget> screens = [

    const HomeScreen(),

    const AttendanceScreen(),

    const UpdateScreen(),

    const ProfileScreen(),
  ];

  void changeTab(int index) {

    selectedIndex = index;

    switch (index) {
      case 0:
        var controller = Get.find<HomeController>();
        controller.loadData();
        break;

      case 1:
        var controller = Get.find<AttendanceController>();
        controller.refreshAttendance();
        break;

      case 2:
        var controller = Get.find<UpdateController>();
        controller.loadData();
        break;

      case 3:
        var controller = Get.find<ProfileController>();
        controller.loadData();
        break;
    }


    update();
  }

  @override
  void onInit() {

    HomeBinding().dependencies();

    AttendanceBinding().dependencies();

    UpdateBinding().dependencies();

    ProfileBinding().dependencies();

    super.onInit();
  }
}


