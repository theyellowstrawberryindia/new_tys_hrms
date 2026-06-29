/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:34 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:34 pm
 *
 */

import '../data/controllers/dashboard_controller.dart';
import '../packages.dart';
import 'common_svg_icon.dart';

class CommonBottomBar extends StatelessWidget {
  const CommonBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Container(
          color: theme.bottomNavigationBarTheme.backgroundColor,

          child: SafeArea(
            top: false,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

              decoration: BoxDecoration(
                color: theme.bottomNavigationBarTheme.backgroundColor,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),

                    blurRadius: 8,
                    spreadRadius: -2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  _navItem(
                    context: context,
                    iconPath: AssetPath.homeIcon,
                    label: "Home",
                    index: 0,
                    controller: controller,
                  ),

                  _navItem(
                    context: context,
                    iconPath: AssetPath.attendanceIcon,
                    label: "Attendance",
                    index: 1,
                    controller: controller,
                  ),

                  _navItem(
                    context: context,
                    iconPath: AssetPath.notificationIcon,
                    label: "Notification",
                    index: 2,
                    controller: controller,
                  ),

                  _navItem(
                    context: context,
                    iconPath: AssetPath.personIcon,
                    label: "Profile",
                    index: 3,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem({
    required BuildContext context,
    required String iconPath,
    required String label,
    required int index,
    required DashboardController controller,
  }) {

    final theme = Theme.of(context);

    final bool isSelected = controller.selectedIndex == index;

    return Expanded(

      child: InkWell(

        borderRadius: BorderRadius.circular(30),

        onTap: () {
          controller.changeTab(index);
        },

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            SizedBox(

              height: 42,

              child: Stack(

                alignment: Alignment.center,

                children: [

                  AnimatedBuilder(

                    animation: controller.navAnimationController,

                    builder: (_, __) {

                      final selected =
                          controller.selectedIndex == index;

                      final width =
                      selected
                          ? (controller.animatingIndex == index
                          ? controller.pillWidthAnimation.value
                          : 54.0)
                          : 0.0;

                      return AnimatedContainer(

                        duration:
                        const Duration(milliseconds: 220),

                        curve: Curves.easeOut,

                        width: width,

                        height: 34,

                        decoration: BoxDecoration(

                          color: AppColor.kPrimaryColor
                              .withValues(alpha: .12),

                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),

                  AnimatedBuilder(

                    animation: controller.iconScaleAnimation,

                    builder: (_, child) {

                      final animate =
                          controller.animatingIndex == index;

                      final scale =
                      animate
                          ? controller.iconScaleAnimation.value
                          : 1.0;

                      final lift =
                      animate
                          ? -(scale - 1) * 18
                          : 0.0;

                      return Transform.translate(

                        offset: Offset(0, lift),

                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      );
                    },

                    child: CommonSvgIcon(

                      asset: iconPath,

                      size: 26,

                      color: isSelected
                          ? theme
                          .bottomNavigationBarTheme
                          .selectedItemColor
                          : theme
                          .bottomNavigationBarTheme
                          .unselectedItemColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            AnimatedDefaultTextStyle(

              duration:
              const Duration(milliseconds: 220),

              curve: Curves.easeOut,

              style: AppTheme.textStyle(

                size: 10,

                weight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,

                color: isSelected
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),

              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
