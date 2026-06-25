/*
 *  Created by Yellow Strawberry LLP on 03/06/26, 3:26 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 03/06/26, 3:26 pm
 *
 */

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/utils/app_storage.dart';
import '../../core/utils/utils.dart';
import '../../packages.dart';
import '../models/attendance_list.dart';
import '../models/leave_status_response.dart';
import '../repository/apply_leave_repository.dart';
import 'attendance_controller.dart';

class ApplyLeaveController extends GetxController {
  final applyLeaveRepository = ApplyLeaveRepository();

  DateTime focusedDay = DateTime.now();

  DateTime? selectedDay;

  DateTime? fromDate;

  DateTime? toDate;

  bool selectingFromDate = true;

  final fromDateController = TextEditingController();

  final toDateController = TextEditingController();

  final leaveReasonController = TextEditingController();

  /// LEAVE SUMMARY

  int totalLeaves = 0;

  double usedLeaves = 0;

  double casualLeaves = 0;

  double sickLeaves = 0;

  double leaveBalance = 0;

  bool isPastAttendanceLeave = false;

  int requestedLeaveDays = 0;

  LeaveStatusResponse? leaveStatusResponse;

  LeaveStatusData? leaveStatus;

  AttendanceData? attendanceData;

  CalendarFormat calendarFormat =
      CalendarFormat.month;

  @override
  void onInit() {
    super.onInit();

    // final data = Get.arguments;
    attendanceData = Get.arguments as AttendanceData?;

    if (attendanceData != null) {
      isPastAttendanceLeave = true;

      final attendanceDate = DateTime.parse(attendanceData!.attDate!);

      fromDate = attendanceDate;

      fromDateController.text = DateFormat(
        'dd MMM yyyy',
      ).format(attendanceDate);

      selectedDay = attendanceDate;

      focusedDay = attendanceDate;
    }
  }

  @override
  void onReady() {
    super.onReady();

    getLeaveStatus();
  }

  ///Leave Day Calculation
  void calculateLeaveDays() {
    if (fromDate == null || toDate == null) {
      requestedLeaveDays = 0;

      update();

      return;
    }

    requestedLeaveDays = toDate!.difference(fromDate!).inDays + 1;

    update();
  }

  Future<void> selectFromDate(DateTime date) async {
    fromDate = date;

    fromDateController.text = "${date.day}/${date.month}/${date.year}";

    update();
  }

  Future<void> selectToDate(DateTime date) async {
    toDate = date;

    toDateController.text = "${date.day}/${date.month}/${date.year}";

    update();
  }

  Future<void> getLeaveStatus() async {
    Loader.showLoader();

    applyLeaveRepository.getLeaveStatus().then(
      (value) {
        Loader.hideLoader();

        leaveStatusResponse = LeaveStatusResponse.fromJson(value);

        if (leaveStatusResponse?.data?.isNotEmpty ?? false) {
          leaveStatus = leaveStatusResponse!.data!.first;

          totalLeaves = leaveStatus?.totalLeave ?? 0;

          leaveBalance = (leaveStatus?.balLeave ?? 0).toDouble();

          usedLeaves = totalLeaves - leaveBalance;

          if (usedLeaves < 0) {
            usedLeaves = 0;
          }

          casualLeaves = leaveBalance;

          /// Until API provides actual value
          sickLeaves = 6;
        }

        update();
      },

      onError: (e) {
        Loader.hideLoader();

        Toast.error(message: e.toString());
      },
    );
  }

  bool validateLeaveRequest() {
    if (fromDate == null) {
      Toast.error(message: "Please select From Date");

      return false;
    }

    if (!isPastAttendanceLeave && toDate == null) {
      Toast.error(message: "Please select To Date");

      return false;
    }

    if (leaveReasonController.text.trim().isEmpty) {
      Toast.error(message: "Please enter reason");

      return false;
    }

    if (!isPastAttendanceLeave && requestedLeaveDays > leaveBalance) {
      Toast.error(message: "You do not have enough leave balance");

      return false;
    }

    return true;
  }

  Future<void> applyLeave() async {
    if (!validateLeaveRequest()) {
      return;
    }

    final currentUser = AppStorage.instance.getUserData();

    final body = {
      "userid": "${currentUser.data.first.userid}",

      "email": currentUser.data.first.email,

      "start_date": DateFormat("yyyy-MM-dd").format(fromDate!),

      "end_date": isPastAttendanceLeave
          ? ""
          : DateFormat("yyyy-MM-dd").format(toDate!),

      "reason": leaveReasonController.text.trim(),

      "appliedOn": DateFormat("yyyy-MM-dd").format(DateTime.now()),

      "leave_type": "",
    };

    AppUtils.printMessage("Leave Request => $body");

    Loader.showLoader();

    applyLeaveRepository
        .applyLeave(body)
        .then(
          (value) {
            Loader.hideLoader();

            if (value['success'] == true) {
              ///REFRESH ATTENDANCE LIST
              final attendanceController = Get.find<AttendanceController>();
              attendanceController.refreshAttendance();

              Get.back();
              Toast.success(message: value['message']);
            } else {
              Toast.error(message: value['message']);
            }
          },

          onError: (e) {
            Loader.hideLoader();

            Toast.error(message: e.toString());
          },
        );
  }
}
