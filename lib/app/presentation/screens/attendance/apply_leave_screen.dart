/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 5:16 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 5:16 pm
 *
 */

import 'package:intl/intl.dart';

import '../../../data/controllers/apply_leave_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/label.dart';
import '../../../widgets/leave_status_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class ApplyLeaveScreen extends GetView<ApplyLeaveController> {
  const ApplyLeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const CommonAppBar(title: "Apply Leave"),

        body: GetBuilder<ApplyLeaveController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  LeaveStatusWidget(controller: controller),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.selectingFromDate = true;
                          },

                          child: Container(
                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),

                              border: Border.all(color: AppColor.kPrimaryColor),
                            ),

                            child: Column(
                              children: [
                                const Text("From Date"),

                                const SizedBox(height: 10),

                                Text(
                                  controller.fromDateController.text.isEmpty
                                      ? "Pick Date"
                                      : controller.fromDateController.text,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      if (!controller.isPastAttendanceLeave)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),

                              border: Border.all(color: AppColor.kPrimaryColor),
                            ),

                            child: Column(
                              children: [
                                const Text("To Date"),

                                const SizedBox(height: 10),

                                Text(
                                  controller.toDateController.text.isEmpty
                                      ? "Pick Date"
                                      : controller.toDateController.text,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (!controller.isPastAttendanceLeave)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),

                      child: Text(
                        "Requested Leave Days : "
                        "${controller.requestedLeaveDays}",

                        style: AppTheme.textStyle(
                          size: 16,

                          weight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (!controller.isPastAttendanceLeave)
                    TableCalendar(
                      firstDay: DateTime.now(),

                      lastDay: DateTime.now().add(const Duration(days: 30)),

                      focusedDay: controller.focusedDay,

                      selectedDayPredicate: (day) {
                        return isSameDay(controller.selectedDay, day);
                      },

                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),

                      onDaySelected: (selectedDay, focusedDay) {
                        controller.selectedDay = selectedDay;

                        controller.focusedDay = focusedDay;

                        if (controller.selectingFromDate) {
                          controller.fromDate = selectedDay;

                          controller.fromDateController.text = DateFormat(
                            'dd MMM yyyy',
                          ).format(selectedDay);

                          controller.selectingFromDate = false;
                        } else {
                          controller.toDate = selectedDay;

                          controller.toDateController.text = DateFormat(
                            'dd MMM yyyy',
                          ).format(selectedDay);

                          controller.selectingFromDate = true;
                        }

                        controller.calculateLeaveDays();

                        controller.update();
                      },
                    ),

                  Label(text: "Reason"),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: controller.leaveReasonController,

                    maxLines: 4,

                    decoration: InputDecoration(
                      hintText: "Enter leave reason",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  CommonButton(
                    text: "Request Leave",

                    onTap: controller.applyLeave,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
