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

    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.kPrimaryColor.withValues(alpha: 0.12)
                  : Colors.transparent,

              borderRadius: BorderRadius.circular(25),
            ),

            child: CommonSvgIcon(
              asset: iconPath,
              size: 28,

              color: isSelected
                  ? theme.bottomNavigationBarTheme.selectedItemColor
                  : theme.bottomNavigationBarTheme.unselectedItemColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,

            style: AppTheme.textStyle(
              size: 10,

              weight: FontWeight.w500,

              color: isSelected
                  ? theme.bottomNavigationBarTheme.selectedItemColor
                  : theme.bottomNavigationBarTheme.unselectedItemColor,
            ),
          ),
        ],
      ),
    );
  }
}
