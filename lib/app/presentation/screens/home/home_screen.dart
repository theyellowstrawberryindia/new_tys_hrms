/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:30 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:30 pm
 *
 */

import 'package:hrms_ys/app/widgets/common_attendance_popup.dart';
import 'package:hrms_ys/app/widgets/common_svg_icon.dart';

import '../../../packages.dart';

import '../../../data/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColor.kPrimaryColor,

              backgroundColor: Theme.of(context).scaffoldBackgroundColor,

              onRefresh: () async {
                await controller.startLocationListener();
                await controller.refreshHome();
              },

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),

                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        /// WELCOME
                        RichText(
                          textAlign: TextAlign.center,

                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome, ",

                                style: AppTheme.textStyle(
                                  size: 24,
                                  weight: FontWeight.w700,
                                  color: AppColor.kPrimaryColor,
                                ),
                              ),

                              TextSpan(
                                text:
                                    controller
                                        .currentUser
                                        ?.data
                                        .first
                                        .firstName ??
                                    "User",
                                style: AppTheme.textStyle(
                                  size: 24,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          controller
                                  .currentUser
                                  ?.professionalDetails
                                  .first
                                  .designation ??
                              "Designation",
                          style: AppTheme.textStyle(
                            size: 16,
                            color: AppColor.kGrayTextColor,
                            weight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 36),

                        /// TIME
                        Text(
                          controller.currentTime,

                          style: AppTheme.textStyle(
                            size: 26,
                            weight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          controller.currentDate,

                          style: AppTheme.textStyle(
                            size: 16,
                            color: AppColor.kGrayTextColor,
                          ),
                        ),

                        const SizedBox(height: 44),

                        /// CLOCK IN BUTTON
                        GestureDetector(
                          onTap: controller.createAttendance,

                          child: Container(
                            width: 180,
                            height: 180,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              gradient: LinearGradient(
                                colors: controller.attendanceGradient,

                                begin: Alignment.topLeft,

                                end: Alignment.bottomRight,
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                CommonSvgIcon(
                                  asset: AssetPath.checkIn,
                                  size: 88,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  controller.attendanceButtonText,

                                  style: AppTheme.textStyle(
                                    size: 16,
                                    weight: FontWeight.w700,

                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// LOCATION
                        Text(
                          controller.isOfficeEmployee
                              ? controller.officeDistance
                              : "Work Location : Remote",
                          style: AppTheme.textStyle(
                            size: 12,
                            color: AppColor.kGrayTextColor,
                          ),
                        ),

                        Text(
                          controller.currentAddress,

                          style: AppTheme.textStyle(
                            size: 10,
                            color: AppColor.kGrayTextColor,
                          ),
                        ),

                        const SizedBox(height: 44),

                        /// STATS CARD
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),

                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,

                            borderRadius: BorderRadius.circular(20),

                            border: Border.all(color: AppColor.kPrimaryColor),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              _item(
                                iconPath: AssetPath.checkInIcon,
                                title: controller.checkInTime,
                                subtitle: "Clock in",
                                color: controller.attendanceColor,
                              ),

                              _item(
                                iconPath: AssetPath.checkOutIcon,
                                title: controller.checkOutTime,
                                subtitle: "Check out",
                                color: controller.attendanceColor,
                              ),

                              _item(
                                iconPath: AssetPath.timeIcon,
                                title: controller.totalHours,
                                subtitle: "Total hours",
                                color: controller.attendanceColor,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _item({
    required String iconPath,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        //Icon(icon, size: 20, color: AppColor.kGrayTextColor),
        CommonSvgIcon(asset: iconPath, size: 20, color: color),
        const SizedBox(height: 12),
        Text(
          title,
          style: AppTheme.textStyle(size: 16, weight: FontWeight.w500),
        ),

        Text(
          subtitle,
          style: AppTheme.textStyle(size: 10, color: AppColor.kGrayTextColor),
        ),
      ],
    );
  }
}
