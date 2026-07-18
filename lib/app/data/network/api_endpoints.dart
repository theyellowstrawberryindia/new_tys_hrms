/*
 *  Created by Yellow Strawberry LLP on 21/05/26, 6:59 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 21/05/26, 6:59 pm
 *
 */


class APIEndpoints{

  ///Base URL
  static const String baseUrl = "https://hrms.tysindia.com/api/v1";

  /// Auth Endpoints
  static const String login = "$baseUrl/login";
  static const String getUser = "$baseUrl/get-user";

  ///ADD ATTENDANCE
  static const String userAttendance = "$baseUrl/user-attendance";
  static const String getTodaysAttendance = "$baseUrl/getTodaysAttendance";

  ///GET ATTENDANCE
  static const String getAttendance = "$baseUrl/get-attendance";

  ///SUBMIT REGULARIZATION
  static const String submitRegularization = "$baseUrl/apply-regularization";

  ///GET LEAVE STATUS
  static const String getLeaveStatus = "$baseUrl/get-leave-status";
  static const String applyLeave = "$baseUrl/apply-leave";

  /// Notifications
  static const String getApprovals = "$baseUrl/get-user-notification";
  static const String getNotifications = "$baseUrl/get-user-pending-notification";

  /// Holidays
  static const String getHolidays = "$baseUrl/get-holidays";

  /// Professional
  static const String editProfessional = "$baseUrl/edit-personal/edit-professional";

  /// Personal
  static const String editPersonal = "$baseUrl/edit-personal/edit-personal";
  static const String editFamily = "$baseUrl/edit-personal/edit-family";
  static const String profilePicture = "$baseUrl/edit-personal/profile-picture";

  /// Bank
  static const String editBank = "$baseUrl/edit-bank";

  /// Education Details
  static const String addEducation = "$baseUrl/add-education";
  static const String editEducation = "$baseUrl/edit-education";
  static const String deleteEducation = "$baseUrl/delete-education";

  ///Project Details
  static const String editProject = "$baseUrl/edit-project";
  static const String addProject = "$baseUrl/add-project";
  static const String deleteProject = "$baseUrl/delete-project";

  /// Privacy Policy
  static const String getPolicy = "$baseUrl/get-policies";
  static const String acceptPolicy = "$baseUrl/accept-policy";


  ///Work Experience
  static const String addWork = "$baseUrl/add-work-experience";
  static const String editWork = "$baseUrl/edit-work-experience";
  static const String deleteWork = "$baseUrl/delete-work-experience";


  static const String postToken = "$baseUrl/add-user-deviceToken";

}
