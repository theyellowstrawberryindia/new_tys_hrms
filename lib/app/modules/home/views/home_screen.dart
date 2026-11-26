/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:30 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:30 pm
 *
 */

import 'package:hrms_ys/app/shared/widgets/common_svg_icon.dart';

import '../../../shared/packages.dart';

import '../../attendance/services/office_geofence.dart';
import '../controllers/home_controller.dart';
import '../widgets/attendance_location_card.dart';
import '../widgets/home_attendance_card.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: AppColor.kPrimaryColor,

              backgroundColor: Theme.of(context).scaffoldBackgroundColor,

              onRefresh: controller.refreshHome,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    25,
                    20,
                    25,
                    20 + MediaQuery.paddingOf(context).bottom,
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
                                      .firstOrNull
                                      ?.firstName ??
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
                                .firstOrNull
                                ?.designation ??
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
                          size: 28,
                          weight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        controller.currentDate,

                        style: AppTheme.textStyle(
                          size: 16,
                          color: AppColor.kGrayTextColor,
                          weight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 44),

                      /// CLOCK IN BUTTON
                      GestureDetector(
                        onTapDown: (_) {
                          controller.onButtonTapDown();
                        },

                        onTapUp: (_) {
                          controller.onButtonTapUp();
                        },

                        onTapCancel: controller.onButtonTapCancel,

                        child: ScaleTransition(
                          scale: controller.pulseAnimation,

                          child: AnimatedBuilder(
                            animation: controller.buttonPressAnimation,

                            builder: (_, child) {
                              return Transform.scale(
                                scale: controller.buttonPressAnimation.value,
                                child: child,
                              );
                            },

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

                                boxShadow: [
                                  BoxShadow(
                                    color: controller.attendanceColor
                                        .withValues(alpha: .2),

                                    blurRadius: 30,

                                    spreadRadius: 2,
                                  ),
                                ],
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
                        ),
                      ),

                      const SizedBox(height: 24),

                      AttendanceLocationCard(
                        message: controller.officeDistance,
                        address: controller.currentAddress,
                        status: controller.lastOfficeLocationStatus,
                        officeRadius: controller.isOfficeEmployee
                            ? HomeController.officeRadius
                            : null,
                        reading: controller.officeLocationReading,
                        isChecking: controller.isVerifyingOfficeLocation,
                        onOpenSettings:
                            controller.locationSettingsTarget == null
                            ? null
                            : controller.openAttendanceLocationSettings,
                        onRefreshLocation:
                            controller.isOfficeEmployee &&
                                controller.lastOfficeLocationStatus !=
                                    OfficeLocationStatus.inside
                            ? controller.refreshOfficeLocation
                            : null,
                      ),

                      const SizedBox(height: 24),

                      /// STATS CARD
                      InkWell(
                        borderRadius: HomeAttendanceCard.borderRadius,

                        onTap: () {
                          Get.find<DashboardController>().changeTab(1);
                        },

                        child: HomeAttendanceCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              _item(
                                iconPath: AssetPath.checkInIcon,
                                title: controller.checkInTime,
                                subtitle: "Clock in",
                                color: controller.attendanceColor,
                                rotation: controller.clockInRotation,
                              ),

                              _item(
                                iconPath: AssetPath.checkOutIcon,
                                title: controller.checkOutTime,
                                subtitle: "Check out",
                                color: controller.attendanceColor,
                                rotation: controller.clockOutRotation,
                              ),

                              _item(
                                iconPath: AssetPath.timeIcon,
                                title: controller.liveTotalHours,
                                subtitle: "Total hours",
                                color: controller.attendanceColor,
                                rotation: controller.totalHourRotation,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
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
    required Animation<double> rotation,
  }) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: rotation,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(0, -2 * rotation.value.abs() * 15),
              child: Transform.rotate(angle: rotation.value, child: child),
            );
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: .08),
              border: Border.all(color: color.withValues(alpha: .15)),
            ),
            child: Center(
              child: CommonSvgIcon(asset: iconPath, size: 20, color: color),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          title,
          style: AppTheme.textStyle(size: 16, weight: FontWeight.w600),
        ),

        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: AppTheme.textStyle(size: 10, color: AppColor.kGrayTextColor),
          child: Text(subtitle),
        ),
      ],
    );
  }
}
