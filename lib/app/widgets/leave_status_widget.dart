/*
 *  Created by Yellow Strawberry LLP on 03/06/26, 3:27 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 03/06/26, 3:27 pm
 *
 */

import '../data/bindings/leave_data_binding.dart';
import '../data/controllers/apply_leave_controller.dart';
import '../packages.dart';
import '../presentation/screens/attendance/leave_data.dart';

class LeaveStatusWidget extends StatelessWidget {
  final ApplyLeaveController controller;

  const LeaveStatusWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Leave Status",
          style: AppTheme.textStyle(size: 20, weight: FontWeight.w700),
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 250,
          width: 250,

          child: Stack(
            alignment: Alignment.center,

            children: [
              SizedBox(
                height: 220,
                width: 220,

                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: controller.leaveBalance,
                  ),

                  duration: const Duration(milliseconds: 1500),

                  curve: Curves.easeOutCubic,

                  builder: (context, progress, child) {
                    return SizedBox(
                      height: 250,
                      width: 250,

                      child: Stack(
                        alignment: Alignment.center,

                        children: [
                          /// OUTER SHADOW
                          Container(
                            height: 220,
                            width: 220,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: Get.isDarkMode
                                      ? Colors.black.withValues(alpha: 0.35)
                                      : Colors.black.withValues(alpha: 0.12),

                                  blurRadius: 25,

                                  spreadRadius: 2,

                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                          ),

                          /// PROGRESS RING
                          SizedBox(
                            height: 220,
                            width: 220,

                            child: CircularProgressIndicator(
                              value: progress,

                              strokeWidth: 12,

                              strokeCap: StrokeCap.round,

                              color: AppColor.kPrimaryColor,

                              backgroundColor: Get.isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300,
                            ),
                          ),

                          /// INNER CIRCLE (tap target -> Leave Data page)
                          Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,

                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Get.to(
                                    () => const LeaveDataPage(),
                                binding: LeaveDataPageBinding(),
                              ),

                              child: Container(
                                height: 190,
                                width: 190,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  color: Get.isDarkMode
                                      ? AppColor.kDarkCardColor
                                      : AppColor.kLightCardColor,

                                  border: Border.all(
                                    color: Get.isDarkMode
                                        ? Colors.white10
                                        : Colors.black12,

                                    width: 1,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Get.isDarkMode
                                          ? Colors.black.withValues(alpha: 0.25)
                                          : Colors.black.withValues(alpha: 0.08),

                                      blurRadius: 15,

                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    /// PL
                                    Text(
                                      "${controller.casualLeaves} PL",

                                      style: AppTheme.textStyle(
                                        size: 16,

                                        weight: FontWeight.bold,

                                        color: AppColor.kSuccessColor,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    /// SL
                                    Text(
                                      "${controller.sickLeaves} SL",

                                      style: AppTheme.textStyle(
                                        size: 16,

                                        weight: FontWeight.bold,

                                        color: AppColor.kErrorColor,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    /// ANIMATED BALANCE
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0,

                                        end: controller.leaveBalance,
                                      ),

                                      duration: const Duration(milliseconds: 1500),

                                      curve: Curves.easeOutCubic,

                                      builder: (context, value, child) {
                                        return Text(
                                          value.toStringAsFixed(1),

                                          style: AppTheme.textStyle(
                                            size: 36,

                                            weight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Leaves Balance",

                                      textAlign: TextAlign.center,

                                      style: AppTheme.textStyle(
                                        size: 14,

                                        color: AppColor.kGrayTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            _item("Total Leaves", controller.totalLeaves.toDouble()),

            //_item("Available Leaves", controller.availableLeaves),

            _item("Leaves Used", controller.usedLeaves),
          ],
        ),
      ],
    );
  }

  Widget _item(String title, double value) {
    return Column(
      children: [
        Text(title, style: AppTheme.textStyle(size: 14)),

        Text(
          value.toString(),
          style: AppTheme.textStyle(size: 22, weight: FontWeight.bold),
        ),
      ],
    );
  }
}