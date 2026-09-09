/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:32 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:32 pm
 *
 */

import 'package:hrms_ys/app/widgets/common_app_bar.dart';

import '../../../packages.dart';
import '../../../data/controllers/update_controller.dart';
import '../../../widgets/common_svg_icon.dart';
import 'approval_screen.dart';
import 'holiday_screen.dart';
import 'notification_screen.dart';


class UpdateScreen extends GetView<UpdateController> {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(title: "Updates", showBackButton: false,),
          body: Column(
            children: [
              Row(
                children: [
                  _tabItem(
                    title: "APPROVALS",
                    icon: AssetPath.approvalIcon,
                    selected: controller.selectedTab == 0,
                    onTap: () => controller.changeTab(0),
                  ),

                  _tabItem(
                    title: "HOLIDAY",
                    icon: AssetPath.holidayIcon,
                    selected: controller.selectedTab == 1,
                    onTap: () => controller.changeTab(1),
                  ),

                  _tabItem(
                    title: "NOTIFICATIONS",
                    icon: AssetPath.notificationIcon,
                    selected: controller.selectedTab == 2,
                    onTap: () => controller.changeTab(2),
                  ),
                ],
              ),

              Divider(
                color: AppColor.kBorderColor,
                height: 1,
              ),

              Expanded(
                child: PageView(
                  controller: controller.pageController,

                  onPageChanged: controller.onPageChanged,

                  children: const [
                    ApprovalScreen(),
                    HolidayScreen(),
                    NotificationScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabItem({
    required String title,
    required String icon,
    required bool selected,
    required VoidCallback onTap,
  })
  {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected
                      ? AppColor.kPrimaryColor
                      : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonSvgIcon(
                  asset: icon,
                  size: 26,
                  color: selected
                      ? AppColor.kPrimaryColor
                      : AppColor.kGrayTextColor,
                ),

                const SizedBox(height: 8),

                Text(
                  title,
                  style: AppTheme.textStyle(
                    size: 11,
                    weight: FontWeight.w600,
                    color: selected
                        ? AppColor.kPrimaryColor
                        : AppColor.kGrayTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
