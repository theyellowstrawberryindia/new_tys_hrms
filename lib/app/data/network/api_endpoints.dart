/*
 *  Created by Yellow Strawberry LLP on 21/05/26, 6:59 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 21/05/26, 6:59 pm
 *
 */


class APIEndpoints{

  //Base URL
  static const String baseUrl = "https://hrms.tysindia.com/api/v1";

  // Auth Endpoints
  static const String login = "$baseUrl/login";
  static const String getUser = "$baseUrl/get-user";

  //ADD ATTENDANCE
  static const String userAttendance = "$baseUrl/user-attendance";
  static const String getTodaysAttendance = "$baseUrl/getTodaysAttendance";

  //GET ATTENDANCE
  static const String getAttendance = "$baseUrl/get-attendance";

  ///SUBMIT REGULARIZATION
  static const String submitRegularization = "$baseUrl/apply-regularization";

  ///GET LEAVE STATUS
  static const String getLeaveStatus = "$baseUrl/get-leave-status";
  static const String applyLeave = "$baseUrl/apply-leave";


  static const String getApprovals = "$baseUrl/get-user-notification";
  static const String getNotifications = "$baseUrl/get-user-pending-notification";
  static const String getHolidays = "$baseUrl/get-holidays";


  static const String profilePicture = "$baseUrl/edit-personal/profile-picture";

  static const String editProfessional = "$baseUrl/edit-personal/edit-professional";
  static const String editPersonal = "$baseUrl/edit-personal/edit-personal";
  static const String editFamily = "$baseUrl/edit-personal/edit-family";
  static const String editBank = "$baseUrl/edit-personal/edit-bank";

  static const String postToken = "$baseUrl/add-user-deviceToken";

}
