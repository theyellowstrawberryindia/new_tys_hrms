/*
 *  Created by Yellow Strawberry LLP on 29/05/26, 1:07 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 29/05/26, 1:07 pm
 *
 */

class Attendance {
  int? id;

  String? inTime;

  String? outTime;

  String? totalHours;

  int? isLate;

  String? attStatus;

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json["id"];

    inTime = json["in_time"];

    outTime = json["out_time"];

    totalHours = json["total_hours"];

    isLate = json["is_late"];

    attStatus = json["att_status"];
  }
}
