/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 3:17 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 3:17 pm
 *
 */


class AttendanceListResponse {

  bool? success;

  int? statusCode;

  List<AttendanceData> data = [];

  AttendanceCount? attendanceCount;

  String? message;

  AttendanceListResponse({
    this.success,
    this.statusCode,
    this.data = const [],
    this.attendanceCount,
    this.message,
  });

  AttendanceListResponse.fromJson(
      Map<String, dynamic> json) {

    success = json['success'];

    statusCode = json['status_code'];

    if (json['data'] != null) {

      data = <AttendanceData>[];

      json['data'].forEach((v) {

        data.add(
          AttendanceData.fromJson(v),
        );
      });
    }

    attendanceCount =
    json['attendanceCount'] != null

        ? AttendanceCount.fromJson(
      json['attendanceCount'],
    )

        : null;

    message = json['message'];
  }
}

class AttendanceData {

  int? id;

  String? userid;

  String? email;

  String? year;

  String? month;

  String? attDate;

  String? attDay;

  String? attStatus;

  int? isApplied;

  String? holiday;

  String? inTime;

  String? outTime;

  String? totalHours;

  int? isLate;

  String? currentAddress;

  String? comments;

  String? createdAt;

  String? updatedAt;

  String? deviceName;

  String? deviceOs;

  AttendanceData.fromJson(
      Map<String, dynamic> json) {

    id = json['id'];

    userid = json['userid'];

    email = json['email'];

    year = json['year'];

    month = json['month'];

    attDate = json['att_date'];

    attDay = json['att_day'];

    attStatus = json['att_status'];

    isApplied = json['isApplied'];

    holiday = json['holiday'];

    inTime = json['in_time'];

    outTime = json['out_time'];

    totalHours = json['total_hours'];

    isLate = json['is_late'];

    currentAddress =
    json['current_address'];

    comments = json['comments'];

    createdAt = json['created_at'];

    updatedAt = json['updated_at'];

    deviceName = json['device_name'];

    deviceOs = json['device_os'];
  }
}

class AttendanceCount {

  int? presentCount;

  int? lateCount;

  int? halfDayCount;

  int? absentCount;

  int? leaveCount;

  int? daysInMonth;

  int? workingDays;

  String? workedInMonth;

  int? totalWorkHourInMonth;

  AttendanceCount.fromJson(
      Map<String, dynamic> json) {

    presentCount =
    json['presentCount'];

    lateCount =
    json['lateCount'];

    halfDayCount =
    json['halfDayCount'];

    absentCount =
    json['absentCount'];

    leaveCount =
    json['leaveCount'];

    daysInMonth =
    json['daysInMonth'];

    workingDays =
    json['workingDays'];

    workedInMonth =
    json['workedInMonth'];

    totalWorkHourInMonth =
    json['totalWorkHourInMonth'];
  }
}