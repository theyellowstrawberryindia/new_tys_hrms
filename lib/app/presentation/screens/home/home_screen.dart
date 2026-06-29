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
                            weight: FontWeight.w500
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

                                      color: controller.attendanceColor.withValues(alpha: .2),

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

                        /// LOCATION
                        Text(
                          controller.isOfficeEmployee
                              ? controller.officeDistance
                              : "Work Location : Remote",
                          style: AppTheme.textStyle(
                            size: 14,
                              color: controller.locationColor,
                            weight: FontWeight.w600
                          ),
                        ),

                        Text(
                          controller.currentAddress,

                          style: AppTheme.textStyle(
                            size: 10,
                              color: controller.locationColor,
                              weight: FontWeight.w600
                          ),
                        ),

                        const SizedBox(height: 44),

                        /// STATS CARD
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),

                          curve: Curves.easeOutCubic,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                          
                              borderRadius: BorderRadius.circular(22),
                          
                              border: Border.all(
                                color: AppColor.kPrimaryColor.withValues(alpha: .18),
                              ),
                          
                              boxShadow: [
                          
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .05),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                ),
                          
                                BoxShadow(
                                  color: AppColor.kPrimaryColor.withValues(alpha: .05),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          
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
                                  title: controller.totalHours,
                                  subtitle: "Total hours",
                                  color: controller.attendanceColor,
                                  rotation: controller.totalHourRotation,
                                ),
                              ],
                            ),
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

    required Animation<double> rotation,
  }) {
    return Column(
      children: [
        AnimatedBuilder(

          animation: rotation,

          builder: (_, child) {

            return Transform.translate(
              offset: Offset(
                0,
                -2 * rotation.value.abs() * 15,
              ),
              child: Transform.rotate(
                angle: rotation.value,
                child: child,
              ),
            );
          },

          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: .08),
              border: Border.all(
                color: color.withValues(alpha: .15),
              ),
            ),
            child: Center(
              child: CommonSvgIcon(
                asset: iconPath,
                size: 20,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        AnimatedSwitcher(

          duration: const Duration(milliseconds: 300),

          transitionBuilder: (child, animation) {

            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },

          child: Text(
            title,

            key: ValueKey(title),

            style: AppTheme.textStyle(
              size: 16,
              weight: FontWeight.w600,
            ),
          ),
        ),

        AnimatedDefaultTextStyle(

          duration: const Duration(milliseconds: 250),

          style: AppTheme.textStyle(
            size: 10,
            color: AppColor.kGrayTextColor,
          ),

          child: Text(subtitle),
        ),
      ],
    );
  }
}
