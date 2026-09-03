/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:30 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:30 pm
 *
 */

import '../../../data/controllers/attendance_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';
import 'attendance_list_item.dart';
import 'attendance_month_header.dart';
import 'attendance_summary_card.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            title: "Attendance",
            showBackButton: false,
            action: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: AppColor.kPrimaryColor),
              ),

              child: DropdownButton<int>(
                value: controller.selectedYear,

                underline: const SizedBox(),

                items: List.generate(5, (index) {
                  final year = DateTime.now().year - 2 + index;

                  return DropdownMenuItem(
                    value: year,

                    child: Text(year.toString(), style: AppTheme.textStyle()),
                  );
                }),

                onChanged: (value) {
                  if (value != null) {
                    controller.changeYear(value);
                  }
                },
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: controller.refreshAttendance,

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              child: Column(
                children: [
                  AttendanceMonthHeader(controller: controller),

                  const SizedBox(height: 20),

                  AttendanceSummaryCard(controller: controller),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),

                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.kBorderColor),
                        bottom: BorderSide(color: AppColor.kBorderColor),
                      ),
                    ),

                    child: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: Center(
                            child: Text(
                              "Date",
                              style: AppTheme.textStyle(size: 10),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "In",
                            textAlign: TextAlign.center,
                            style: AppTheme.textStyle(size: 10),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "Out",
                            textAlign: TextAlign.center,
                            style: AppTheme.textStyle(size: 10),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            "Total hours",
                            textAlign: TextAlign.center,
                            style: AppTheme.textStyle(size: 10),
                          ),
                        ),

                        SizedBox(width: 40),
                      ],
                    ),
                  ),

                  ListView.builder(
                    itemCount: controller.filteredAttendanceList.length,

                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {

                      final item = controller.filteredAttendanceList[index];
                      //AppUtils.printMessage("attendanceId -- ${item.id.toString()}");

                      return AttendanceListItem(

                        date: item.attDate?.split('-').last ?? "--",

                        day: item.attDay?.substring(0, 3) ?? "--",

                        inTime: item.inTime ?? "-",

                        outTime: item.outTime == "00:00:00"
                            ? "-"
                            : item.outTime ?? "-",

                        totalHours: item.totalHours ?? "-",

                        statusColor: controller.getStatusColor(item.attStatus),

                        attendanceData: item,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
