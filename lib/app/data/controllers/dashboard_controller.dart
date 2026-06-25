/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:00 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:00 pm
 *
 */
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

    if(index == 1){
      Get.find<AttendanceController>()
          .refreshAttendance();
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


