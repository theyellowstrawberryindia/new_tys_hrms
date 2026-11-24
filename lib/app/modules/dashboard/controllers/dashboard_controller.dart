/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:00 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:00 pm
 *
 */
import 'package:hrms_ys/app/modules/home/controllers/home_controller.dart';
import 'package:hrms_ys/app/modules/profile/controllers/profile_controller.dart';
import 'package:hrms_ys/app/modules/updates/controllers/update_controller.dart';

import '../../../shared/packages.dart';
import '../../attendance/views/attendance_screen.dart';
import '../../home/views/home_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../../updates/views/update_screen.dart';
import '../../attendance/bindings/attendance_binding.dart';
import '../../home/bindings/home_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../updates/bindings/update_binding.dart';
import '../../attendance/controllers/attendance_controller.dart';

/// For your HRMS project,
/// (controllers registered once, APIs loaded on demand with a _loaded flag
/// and explicit loadData() methods) is the architecture
/// It fits well with GetX, 'preserves your existing navigation logic,
/// and avoids the complexity of creating and destroying controllers dynamically.

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  int selectedIndex = 0;

  /// Bottom Navigation Animation
  ///

  late AnimationController navAnimationController;

  late Animation<double> iconScaleAnimation;

  late Animation<double> pillWidthAnimation;

  int animatingIndex = -1;


  final List<Widget> screens = [
    const HomeScreen(),

    const AttendanceScreen(),

    const UpdateScreen(),

    const ProfileScreen(),


  ];

  Future<void> changeTab(int index) async {

    if (selectedIndex == index) return;

    animatingIndex = index;
    selectedIndex = index;
    navAnimationController.forward(from: 0);
    update();

    switch (index) {

      case 0:
        Get.find<HomeController>().loadData();
        break;

      case 1:
        Get.find<AttendanceController>().refreshAttendance();
        break;

      case 2:
        Get.find<UpdateController>().loadData();
        break;

      case 3:
        Get.find<ProfileController>().loadData();
        break;
    }


  }


  @override
  void onInit() {
    HomeBinding().dependencies();

    AttendanceBinding().dependencies();

    UpdateBinding().dependencies();

    ProfileBinding().dependencies();

    super.onInit();

    _initBottomAnimation();
  }

  void _initBottomAnimation() {

    navAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.12, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
    ]).animate(navAnimationController);

    pillWidthAnimation = Tween<double>(
      begin: 0,
      end: 54,
    ).animate(
      CurvedAnimation(
        parent: navAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void onClose() {
    navAnimationController.dispose();

    super.onClose();
  }
}
