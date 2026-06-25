/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 2:58 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 2:58 pm
 *
 */

/*
 *  Created by Yellow Strawberry LLP
 */

import '../../../data/controllers/attendance_controller.dart';
import '../../../packages.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final AttendanceController controller;

  const AttendanceSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          /// TITLE
          Text(
            "Total",

            style: AppTheme.textStyle(size: 16, weight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          /// DAYS / HOURS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "Days",
                style: AppTheme.textStyle(
                  color: AppColor.kGrayTextColor,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "|",
                style: AppTheme.textStyle(
                  color: AppColor.kGrayTextColor,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "${controller.presentDays}/30",
                style: AppTheme.textStyle( weight: FontWeight.w600),
              ),

              const SizedBox(width: 30),

              Text(
                "Hours",
                style: AppTheme.textStyle(
                  color: AppColor.kGrayTextColor,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "|",
                style: AppTheme.textStyle(
                  color: AppColor.kGrayTextColor,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "${controller.completedHours}/225",
                style: AppTheme.textStyle( weight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _summaryItem(
                  label: "PRESENT",
                  value: "${controller.presentDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                  color: AppColor.kSuccessColor,
                  progress: controller.presentDays / 30,
                ),
              ),

              Expanded(
                child: _summaryItem(
                  label: "ABSENT",
                  value: "${controller.absentDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                  color: AppColor.kErrorColor,
                  progress: controller.absentDays / 30,
                ),
              ),

              Expanded(
                child: _summaryItem(
                  label: "LATE",
                  value: "${controller.lateDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                  color: Colors.amber,
                  progress: controller.lateDays / 30,
                ),
              ),

              Expanded(
                child: _summaryItem(
                  label: "LEAVE",
                  value: "${controller.leaveDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                  color: Colors.blue,
                  progress: controller.leaveDays / 30,
                ),
              ),

              Expanded(
                child: _summaryItem(
                  label: "HALF DAY",
                  value: "${controller.halfDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                  color: Colors.purple,
                  progress: controller.halfDays / 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String label,

    required String value,

    required Color color,

    required double progress,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          width: 44,

          child: Stack(
            alignment: Alignment.center,

            children: [
              CircularProgressIndicator(
                value: progress.clamp(0, 1),

                strokeWidth: 6,

                backgroundColor: color.withValues(alpha: 0.15),

                valueColor: AlwaysStoppedAnimation(color),
              ),

              Container(
                height: 44,
                width: 44,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,

          style: AppTheme.textStyle(size: 16, weight: FontWeight.w600),
        ),

        Text(
          label,

          textAlign: TextAlign.center,

          style: AppTheme.textStyle(size: 10, color: AppColor.kGrayTextColor),
        ),
      ],
    );
  }
}
