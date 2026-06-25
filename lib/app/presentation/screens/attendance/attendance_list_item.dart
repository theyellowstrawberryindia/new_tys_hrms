/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 3:19 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 3:19 pm
 *
 */

import 'package:hrms_ys/app/data/bindings/regularize_binding.dart';
import 'package:hrms_ys/app/presentation/screens/attendance/regularize_screen.dart';

import '../../../data/bindings/apple_leave_binding.dart';
import '../../../data/models/attendance_list.dart';
import '../../../packages.dart';
import '../../../widgets/common_attendance_action_menu.dart';
import 'apply_leave_screen.dart';

class AttendanceListItem extends StatelessWidget {
  final String date;

  final String day;

  final String inTime;

  final String outTime;

  final String totalHours;

  final Color statusColor;

  final AttendanceData attendanceData;



  const AttendanceListItem({
    super.key,
    required this.date,
    required this.day,
    required this.inTime,
    required this.outTime,
    required this.totalHours,
    required this.statusColor,
    required this.attendanceData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.kBorderColor, width: 1),
        ),
      ),

      child: Row(
        children: [
          /// DATE BOX
          Container(
            width: 44,

            height: 44,

            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),

              borderRadius: BorderRadius.circular(8),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  date,

                  style: AppTheme.textStyle(size: 12, weight: FontWeight.w600),
                ),

                Text(
                  day,

                  style: AppTheme.textStyle(size: 12, weight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// IN TIME
          Expanded(
            child: Text(
              inTime,

              textAlign: TextAlign.center,

              style: AppTheme.textStyle(
                size: 12,

                weight: FontWeight.w600,

                color: statusColor,
              ),
            ),
          ),

          /// OUT TIME
          Expanded(
            child: Text(
              outTime,

              textAlign: TextAlign.center,

              style: AppTheme.textStyle(
                size: 12,

                weight: FontWeight.w600,

                color: statusColor,
              ),
            ),
          ),

          /// TOTAL HOURS
          Expanded(
            child: Text(
              totalHours,

              textAlign: TextAlign.center,

              style: AppTheme.textStyle(
                size: 12,

                weight: FontWeight.w600,

                color: statusColor,
              ),
            ),
          ),

          if(attendanceData.isApplied == 1)
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
              ),
            ),

          /// MORE
          if(attendanceData.isApplied == 0)
            CommonAttendanceActionMenu(
            onRegularize: () {
              Get.to(
                () => const RegularizeScreen(),
                binding: RegularizeBinding(),
                arguments: attendanceData,
              );
            },
            onApplyLeave: () {
              Get.to(
                () => ApplyLeaveScreen(),
                 binding: ApplyLeaveBinding(),
                arguments: attendanceData,
              );
            },
          ),
        ],
      ),
    );
  }
}
