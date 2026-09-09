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
                  "${controller.presentDays}/${controller.workingDays}",
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
                "${controller.completedHours}/ ${controller.workingHoursInMonth}",
                style: AppTheme.textStyle( weight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    controller.filterAttendance(AttendanceFilter.present);
                  },
                  child: _summaryItem(
                    label: "PRESENT",
                    value: "${controller.presentDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                    color: AppColor.kSuccessColor,
                    context: context,
                    progress: controller.presentDays / controller.workingDays,
                    isSelected:
                    controller.selectedFilter == AttendanceFilter.present,

                    onTap: () {
                      controller.filterAttendance(AttendanceFilter.present);
                    },
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: (){
                    controller.filterAttendance(AttendanceFilter.absent);
                  },
                  child: _summaryItem(
                    label: "ABSENT",
                    value: "${controller.absentDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                    color: AppColor.kErrorColor,
                    context: context,
                    progress: controller.absentDays / controller.workingDays,
                    isSelected:
                    controller.selectedFilter == AttendanceFilter.absent,

                    onTap: () {
                      controller.filterAttendance(AttendanceFilter.absent);
                    },
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: (){
                    controller.filterAttendance(AttendanceFilter.late);
                  },
                  child: _summaryItem(
                    label: "LATE",
                    value: "${controller.lateDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                    color: Colors.amber,
                    context: context,
                    progress: controller.lateDays / controller.workingDays,
                    isSelected:
                    controller.selectedFilter == AttendanceFilter.late,

                    onTap: () {
                      controller.filterAttendance(AttendanceFilter.late);
                    },
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: (){
                    controller.filterAttendance(AttendanceFilter.leave);
                  },
                  child: _summaryItem(
                    label: "LEAVE",
                    value: "${controller.leaveDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                    color: Colors.blue,
                    context: context,
                    progress: controller.leaveDays / controller.workingDays,
                    isSelected:
                    controller.selectedFilter == AttendanceFilter.leave,
                    onTap: () {
                      controller.filterAttendance(AttendanceFilter.leave);
                    },
                  ),
                ),
              ),

              Expanded(
                child: InkWell(
                  onTap: (){
                    controller.filterAttendance(AttendanceFilter.halfDay);
                  },
                  child: _summaryItem(
                    label: "HALF DAY",
                    value: "${controller.halfDays}/${controller.attendanceResponse?.attendanceCount?.workingDays ?? 0}",
                    color: Colors.purple,
                    context: context,
                    progress: controller.halfDays / controller.workingDays,
                    isSelected:
                    controller.selectedFilter == AttendanceFilter.halfDay,
                    onTap: () {
                      controller.filterAttendance(AttendanceFilter.halfDay);
                    }
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
    required double progress,

    /// NEW
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.all(6),

        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.10)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: isSelected
                ? color
                : Colors.transparent,
            width: 1.5,
          ),
        ),

        child: Column(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
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
                      border: Border.all(
                        color: color.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: AppTheme.textStyle(
                size: 12,
                weight: FontWeight.w600,
              ),
            ),

            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTheme.textStyle(
                size: 10,
                color: AppColor.kGrayTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
