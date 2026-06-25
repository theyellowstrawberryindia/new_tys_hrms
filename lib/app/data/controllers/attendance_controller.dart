/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:37 pm
 *
 */

import 'package:hrms_ys/app/data/models/attendance_list.dart';
import 'package:hrms_ys/app/data/repository/attendance_repository.dart';

import '../../packages.dart';


class AttendanceController extends GetxController {

  final attendanceRepository = AttendanceRepository();

  final ScrollController monthScrollController = ScrollController();

  final reimbursementVendorController = TextEditingController();

  final reimbursementAmountController = TextEditingController();

  final reimbursementUpiController = TextEditingController();

  final reimbursementCommentController = TextEditingController();

  DateTime? selectedRegularizeDate;

  DateTime? selectedExpenseDate;

  TimeOfDay? checkInTime;

  TimeOfDay? checkOutTime;

  String selectedExpenseCategory = "Select Category";

  int presentDays = 25;

  int absentDays = 1;

  int lateDays = 2;

  int leaveDays = 0;

  int halfDays = 0;

  int completedHours = 97;

  int selectedYear = DateTime.now().year;

  int selectedMonth = DateTime.now().month;

  AttendanceListResponse? attendanceResponse;

  List<AttendanceData> attendanceList = [];

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  String get selectedMonthName {
    return months[selectedMonth - 1];
  }



  @override
  void onReady() {
    // TODO: implement onReady
    getAttendanceHistory();

    super.onReady();
  }

  void changeMonth(int month) {
    selectedMonth = month;

    update();

    scrollToSelectedMonth();

    getAttendanceHistory();
  }

  void changeYear(int year) {
    selectedYear = year;

    update();

    getAttendanceHistory();
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case "Present":
        return AppColor.kSuccessColor;

      case "Late":
        return Colors.amber;

      case "Absent":
        return AppColor.kErrorColor;

      case "Leave":
        return Colors.blue;

      case "Halfday":
        return Colors.purple;

      default:
        return AppColor.kGrayTextColor;
    }
  }

  /// SCROLL TO CENTER
  void scrollToSelectedMonth() {
    if (!monthScrollController.hasClients) {
      return;
    }

    const double itemWidth = 110;

    final screenWidth = Get.width;

    final targetOffset =
        ((selectedMonth - 1) * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    monthScrollController.animateTo(
      targetOffset < 0 ? 0 : targetOffset,

      duration: const Duration(milliseconds: 300),

      curve: Curves.easeInOut,
    );
  }

  void resetFilters() {
    selectedYear = DateTime.now().year;

    selectedMonth = DateTime.now().month;
  }


  ///REFRESH
  Future<void> refreshAttendance() async {
    selectedYear = DateTime.now().year;

    selectedMonth = DateTime.now().month;

    attendanceList.clear();

    update();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedMonth();
    });

    await Future.delayed(const Duration(milliseconds: 300));

    getAttendanceHistory();
  }

  ///GET ATTENDANCE
  void getAttendanceHistory() {

    Loader.showLoader();

    Map<String, dynamic> body = {
      'year': selectedYear,
      'month': selectedMonthName,
    };
    attendanceRepository
        .getAttendance(body)
        .then(
          (value) {
            Loader.hideLoader();

            attendanceResponse = AttendanceListResponse.fromJson(value);

            attendanceList = attendanceResponse?.data ?? [];

            final summary = attendanceResponse?.attendanceCount;

            presentDays = summary?.presentCount ?? 0;

            absentDays = summary?.absentCount ?? 0;

            lateDays = summary?.lateCount ?? 0;

            leaveDays = summary?.leaveCount ?? 0;

            halfDays = summary?.halfDayCount ?? 0;

            completedHours =
                int.tryParse(summary?.workedInMonth?.split(':').first ?? "0") ??
                0;

            update();
          },
          onError: (e) {
            Loader.hideLoader();

            Toast.error(message: e);
          },
        );
  }

}
