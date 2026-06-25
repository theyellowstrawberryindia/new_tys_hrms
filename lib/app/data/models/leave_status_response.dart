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
