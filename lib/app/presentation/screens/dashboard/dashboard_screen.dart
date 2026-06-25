/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 12:57 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 12:57 pm
 *
 */
import '../../../data/controllers/dashboard_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_bottom_bar.dart';


class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

          resizeToAvoidBottomInset: false,

          body: IndexedStack(
            index: controller.selectedIndex,
            children: controller.screens,
          ),

          bottomNavigationBar: const CommonBottomBar(),
        );
      },
    );
  }
}