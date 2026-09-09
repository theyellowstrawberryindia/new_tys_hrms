/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:37 pm
 *
 */

import 'package:hrms_ys/app/data/models/attendance_list.dart';
import 'package:hrms_ys/app/data/repository/attendance_repository.dart';

import '../../packages.dart';
import '../models/update_item_model.dart';
import '../repository/update_repository.dart';

enum AttendanceFilter {
  all,
  present,
  absent,
  late,
  leave,
  halfDay,
}


class AttendanceController extends GetxController {

  final attendanceRepository = AttendanceRepository();

  final updateRepository = UpdateRepository();

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

  List<UpdateItem> approvalList = [];

  List<AttendanceData> filteredAttendanceList = [];

  AttendanceFilter selectedFilter = AttendanceFilter.all;

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
  bool get isFutureMonth {
    final now = DateTime.now();

    if (selectedYear > now.year) return true;

    if (selectedYear == now.year && selectedMonth > now.month) return true;

    return false;
  }


  @override
  void onReady() {
    // TODO: implement onReady
    //getAttendanceHistory();

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

  int get totalDaysInMonth {
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }

  int get workingDays {
    return attendanceResponse?.attendanceCount?.workingDays ?? totalDaysInMonth;
  }

  int get workingHoursInMonth {
    return workingDays * 9;
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

            filteredAttendanceList = List.from(attendanceList);
            selectedFilter = AttendanceFilter.all;

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

  Future<UpdateItem?> findApprovalForAttendance(String? attDate) async {
    if (attDate == null) return null;

    if (approvalList.isEmpty) {
      try {
        final value = await updateRepository.getApprovals();
        approvalList = (value['data'] as List).map((e) => UpdateItem.fromJson(e)).toList();
      } catch (e) {
        Toast.error(message: e.toString());
        return null;
      }
    }

    for (final item in approvalList) {
      if (item.label == "RG" && item.attDate == attDate) {
        return item;
      }
      if (item.label == "LV" && item.startDate != null && item.endDate != null) {
        final date = DateTime.tryParse(attDate);
        final start = DateTime.tryParse(item.startDate!);
        final end = DateTime.tryParse(item.endDate!);
        if (date != null && start != null && end != null &&
            !date.isBefore(start) && !date.isAfter(end)) {
          return item;
        }
      }
    }
    return null;
  }
  void filterAttendance(AttendanceFilter filter) {

    /// Toggle
    if (selectedFilter == filter) {
      filter = AttendanceFilter.all;
    }

    selectedFilter = filter;

    switch (filter) {

      case AttendanceFilter.all:
        filteredAttendanceList = List.from(attendanceList);
        break;

      case AttendanceFilter.present:
        filteredAttendanceList =
            attendanceList.where((e) => e.attStatus == "Present").toList();
        break;

      case AttendanceFilter.late:
        filteredAttendanceList =
            attendanceList.where((e) => e.isLate == 1).toList();
        break;

      case AttendanceFilter.absent:
        filteredAttendanceList =
            attendanceList.where((e) => e.attStatus == "Absent").toList();
        break;

      case AttendanceFilter.leave:
        filteredAttendanceList =
            attendanceList.where((e) => e.attStatus == "Leave").toList();
        break;

      case AttendanceFilter.halfDay:
        filteredAttendanceList =
            attendanceList.where((e) => e.attStatus == "Half Day").toList();
        break;
    }

    update();
  }

}
