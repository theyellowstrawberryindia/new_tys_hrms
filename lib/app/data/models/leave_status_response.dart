/*
 *  Created by Yellow Strawberry LLP on 03/06/26, 4:18 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 03/06/26, 4:18 pm
 *
 */

class LeaveStatusResponse {
  bool? success;

  int? statusCode;

  List<LeaveStatusData>? data;

  String? message;

  LeaveStatusResponse({this.success, this.statusCode, this.data, this.message});

  LeaveStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    statusCode = json['status_code'];

    if (json['data'] != null) {
      data = <LeaveStatusData>[];

      json['data'].forEach((v) {
        data!.add(LeaveStatusData.fromJson(v));
      });
    }

    message = json['message'];
  }
}

class LeaveStatusData {
  int? id;

  String? userid;

  String? email;

  dynamic totalLeave;

  dynamic balLeave;

  dynamic availLeave;

  String? createdAt;

  String? updatedAt;

  LeaveStatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    userid = json['userid'];

    email = json['email'];

    totalLeave = json['total_leave'];

    balLeave = json['bal_leave'];

    availLeave = json['avail_leave'];

    createdAt = json['created_at'];

    updatedAt = json['updated_at'];
  }
}
class LeaveTermStatusResponse {
  bool? success;
  int? statusCode;
  List<LeaveTermStatusData>? data;
  String? message;

  LeaveTermStatusResponse({this.success, this.statusCode, this.data, this.message});

  LeaveTermStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];

    if (json['data'] != null) {
      data = <LeaveTermStatusData>[];
      json['data'].forEach((v) {
        data!.add(LeaveTermStatusData.fromJson(v));
      });
    }

    message = json['message'];
  }
}

class LeaveTermStatusData {
  int? id; // <-- this is the termId used to call get-leave-term-details
  int? userid;
  String? email;
  String? termStartDate;
  String? termEndDate;
  String? term; // e.g. "2025-2026" -> shown in the dropdown
  dynamic prevYearBalLeave;
  dynamic prevYearUsedLeave;
  dynamic prevYearAssignedLeave;
  String? createdAt;
  String? updatedAt;

  LeaveTermStatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    email = json['email'];
    termStartDate = json['term_start_date'];
    termEndDate = json['term_end_date'];
    term = json['term'];
    prevYearBalLeave = json['prev_year_bal_leave'];
    prevYearUsedLeave = json['prev_year_used_leave'];
    prevYearAssignedLeave = json['prev_year_assigned_leave'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}


class LeaveTermDetailsResponse {
  bool? success;
  int? statusCode;
  List<LeaveTermDetailsData>? data;
  String? message;

  LeaveTermDetailsResponse({this.success, this.statusCode, this.data, this.message});

  LeaveTermDetailsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['status_code'];

    if (json['data'] != null) {
      data = <LeaveTermDetailsData>[];
      json['data'].forEach((v) {
        data!.add(LeaveTermDetailsData.fromJson(v));
      });
    }

    message = json['message'];
  }
}

class LeaveTermDetailsData {
  int? id;
  String? userid;
  String? email;
  String? year;
  String? month;
  String? attDate; // Date
  String? attDay; // Day
  String? attStatus; // Status (Halfday / Leave / Present ...)
  int? isApplied;
  String? holiday; // "0" / "1"
  String? inTime;
  String? outTime;
  String? totalHours;
  int? isLate; // 0 = on time, non-zero = not on time (see helper below)
  String? currentAddress;
  String? coordinate;
  String? comments;
  String? createdAt;
  String? updatedAt;
  String? ipAddress;
  String? photo;
  String? deviceName;
  String? deviceOs;

  LeaveTermDetailsData.fromJson(Map<String, dynamic> json) {
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
    currentAddress = json['current_address'];
    coordinate = json['coordinate'];
    comments = json['comments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ipAddress = json['ip_address'];
    photo = json['photo'];
    deviceName = json['device_name'];
    deviceOs = json['device_os'];
  }
}
