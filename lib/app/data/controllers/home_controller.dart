/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:36 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:36 pm
 *
 */

import 'dart:io';

import 'package:hrms_ys/app/core/core.dart';
import 'package:hrms_ys/app/core/utils/app_storage.dart';
import 'package:hrms_ys/app/data/controllers/profile_controller.dart';
import 'package:hrms_ys/app/widgets/common_attendance_popup.dart';
import 'package:hrms_ys/app/widgets/common_confirmation_dialog.dart';

import '../../packages.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../../presentation/screens/home/attendance_camera_screen.dart';
import '../../services/device_info_service.dart';
import '../../services/location_service.dart';

import 'package:geolocator/geolocator.dart';
import '../models/attendance_data.dart';
import '../models/current_user.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  final homeRepository = HomeRepository();

  /// TIME
  String currentTime = "";
  String currentDate = "";

  /// LOCATION
  String officeDistance = "Getting Location...";
  String currentAddress = "";

  Position? currentPosition;

  /// OFFICE LOCATION
  final double officeLat = 19.0667379;
  final double officeLng = 73.0082772;

  /// OFFICE STATUS
  bool isInsideOfficeRadius = false;
  bool canClockIn = false;

  Timer? timer;

  StreamSubscription<Position>? positionStream;

  ///CURRENT USER
  CurrentUser? currentUser;

  /// ATTENDANCE UI
  Attendance? todayAttendance;

  bool isCheckedIn = false;

  bool isCheckedOut = false;

  bool isLateCheckIn = false;

  String checkInTime = "--:--";

  String checkOutTime = "--:--";

  String totalHours = "--:--";

  String attendanceDate = "";

  bool get shouldShowCheckoutConfirmation {
    return isCheckedIn;
  }

  String get attendanceConfirmationMessage {
    if (!isCheckedIn) {
      return "";
    }

    if (isCheckedOut) {
      return "You have already checked out today. Do you want to update your check-out time?";
    }

    return "Are you ready to check-out at this time?";
  }


  bool get isOfficeEmployee {
    return currentUser?.data.first.workLocation
        ?.toLowerCase()
        .trim() ==
        "office";
  }


  @override
  void onInit() {
    super.onInit();

    _updateTime();

    _startClock();

    startLocationListener();
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    _getUser();
    _getTodaysAttendance();
  }

  /// Refresh
  Future<void> refreshHome() async {
    await startLocationListener();
    _getUser();
  }

  /// CLOCK
  void _startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  /// UPDATE TIME
  void _updateTime() {
    final now = DateTime.now();

    currentTime = DateFormat("HH:mm").format(now);

    currentDate = DateFormat("EEEE | MMM dd").format(now);

    validateAttendanceDay();

    update();
  }

  /// ATTENDANCE UI

  void updateAttendanceUI(Map<String, dynamic> response) {
    ///RESET
    attendanceDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (response["data"] == null || response["data"].isEmpty) {
      resetAttendanceUI();

      return;
    }

    todayAttendance = Attendance.fromJson(response["data"][0]);

    isLateCheckIn = todayAttendance?.isLate == 1;

    checkInTime = todayAttendance?.inTime ?? "--:--";

    checkOutTime = todayAttendance?.outTime ?? "--:--";

    totalHours = todayAttendance?.totalHours ?? "--:--";

    isCheckedIn = checkInTime != "00:00:00" && checkInTime.isNotEmpty;

    isCheckedOut = checkOutTime != "00:00:00" && checkOutTime.isNotEmpty;

    update();
  }

  void resetAttendanceUI() {
    attendanceDate = "";

    todayAttendance = null;

    isCheckedIn = false;

    isCheckedOut = false;

    isLateCheckIn = false;

    checkInTime = "--:--";

    checkOutTime = "--:--";

    totalHours = "--:--";

    update();
  }

  void validateAttendanceDay() {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (attendanceDate.isEmpty) {
      return;
    }

    if (attendanceDate != today) {
      resetAttendanceUI();

      AppUtils.printMessage("Attendance UI Reset - New Day");
    }
  }

  Color get attendanceColor {
    if (!isCheckedIn) {
      return AppColor.kPrimaryColor;
    }

    return isLateCheckIn ? AppColor.kCheckOutRed_1 : AppColor.kCheckOutGreen_1;
  }

  List<Color> get attendanceGradient {
    if (!isCheckedIn) {
      return [AppColor.kButtonLinearColor_1, AppColor.kButtonLinearColor_2];
    }

    return isLateCheckIn
        ? [AppColor.kCheckOutRed_1, AppColor.kCheckOutRed_2]
        : [AppColor.kCheckOutGreen_1, AppColor.kCheckOutGreen_2];
  }

  String get attendanceButtonText {
    if (!isCheckedIn) {
      return "Check-in";
    }

    if (!isCheckedOut) {
      return "Check-out";
    }

    return "Check-out";
  }

  /// START LOCATION LISTENER
  Future<void> startLocationListener() async {
    try {
      final hasPermission = await LocationService.handlePermission();

      if (!hasPermission) {
        officeDistance = "Location permission denied";

        update();

        return;
      }

      positionStream = LocationService.getPositionStream().listen((
        Position position,
      ) async {
        currentPosition = position;

        /// PRINT CURRENT LOCATION
        AppUtils.printMessage("Latitude : ${position.latitude}");

        AppUtils.printMessage("Longitude : ${position.longitude}");

        AppUtils.printMessage("Accuracy : ${position.accuracy}");

        AppUtils.printMessage("Speed : ${position.speed}");

        /// ADDRESS
        currentAddress = await LocationService.getAddressFromLatLng(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        AppUtils.printMessage("Current Address : $currentAddress");

        /// DISTANCE
        final distance = LocationService.calculateDistance(
          startLatitude: position.latitude,

          startLongitude: position.longitude,

          endLatitude: officeLat,

          endLongitude: officeLng,
        );

        AppUtils.printMessage(
          "Distance From Office : ${distance.toStringAsFixed(1)} meter",
        );

        if (isOfficeEmployee) {
          officeDistance =
          "You are ${distance.toStringAsFixed(1)} meter away from office";
        } else {
          officeDistance =
          "Remote Working Location";
        }


        /// 50 METER RADIUS
        isInsideOfficeRadius = distance <= 50;

        /// OFFICE EMPLOYEE => 50 meter rule
        /// REMOTE EMPLOYEE => anywhere
        canClockIn = isOfficeEmployee
            ? distance <= 50
            : true;


        AppUtils.printMessage("Inside Office Radius : $isInsideOfficeRadius");

        AppUtils.printMessage("Can Clock In : $canClockIn");

        update();
      });
    } catch (e) {
      officeDistance = "Unable to fetch location";

      update();
    }
  }

  /// CREATE ATTENDANCE

  Future<void> createAttendance() async {
    try {

      if (isOfficeEmployee && !canClockIn) {
        Toast.error(
          message: "You must be within 50 meters of the office to check in",
        );
        return;
      }

      /// CHECK-OUT CONFIRMATION
      if (shouldShowCheckoutConfirmation) {
        final bool confirm = await CommonConfirmationDialog.show(
          title: "Attendance",

          message: attendanceConfirmationMessage,

          description:
              "You have completed ${totalHours == '00:00' ? getWorkedHours() : totalHours} for the day.",

          positiveText: isCheckedOut ? "Update" : "Check-out",

          //icon: Icons.access_time,

          positiveColor: AppColor.kCheckOutRed_1,
        );

        if (!confirm) {
          return;
        }
      }

      /// OPEN CAMERA
      final dynamic result = await Get.to(() => const AttendanceCameraScreen());

      if (result == null) {
        Toast.error(message: "Selfie capture cancelled");
        return;
      }

      final File image = result as File;

      Loader.showLoader();

      /// DEVICE INFO
      final deviceInfo = await DeviceInfoService.getDeviceData();

      Map<String, String> body = {
        "email": currentUser?.data.first.email ?? "",
        "current_address": currentAddress,
        "latitude": "${currentPosition?.latitude}",
        "longitude": "${currentPosition?.longitude}",
        "device_os": deviceInfo["device_os"],
        "device_name": deviceInfo["device_name"],
        "ip_address": "",
      };

      final response = await homeRepository.createAttendance(body, image);

      Loader.hideLoader();

      ///Update UI
      updateAttendanceUI(response);

      /// POPUP
      if (response["data"] != null && response["data"].isNotEmpty) {
        final data = response["data"][0];

        if (data["out_time"] == "00:00:00") {
          CommonAttendancePopup.show(
            isLate: data["is_late"] == 1,

            time: data["in_time"],
          );
        }
      }

      Toast.success(
        message: response["message"] ?? "Attendance marked successfully",
      );
    } catch (e) {
      Loader.hideLoader();
      Toast.error(message: e.toString());
    }
  }

  /// GET USER
  void _getUser() {
    Loader.showLoader();
    homeRepository.getUser().then(
      (value) {
        Loader.hideLoader();
        currentUser = CurrentUser.fromJson(value);
        AppStorage.instance.setUserData(currentUser!);

        ///Refresh user
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().loadCurrentUser();
        }
        AppUtils.printMessage(
          "Get User - ${currentUser!.data.first.firstName}",
        );

        /// call Post token
        _postToken();

      },
      onError: (e) {
        Loader.hideLoader();
        Toast.error(message: e);
      },
    );
  }

  void _getTodaysAttendance() {
    Loader.showLoader();
    homeRepository.getTodaysAttendance().then(
      (value) {
        Loader.hideLoader();

        updateAttendanceUI(value);

        AppUtils.printMessage("getTodaysAttendance - $value");
      },
      onError: (e) {
        Loader.hideLoader();
        Toast.error(message: e);
      },
    );
  }

  String getWorkedHours() {
    if (!isCheckedIn) {
      return "0 hours";
    }

    try {
      final now = DateTime.now();

      final inParts = checkInTime.split(":");

      final checkInDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(inParts[0]),
        int.parse(inParts[1]),
        int.parse(inParts[2]),
      );

      final diff = now.difference(checkInDate);

      final hours = diff.inHours;

      final minutes = diff.inMinutes % 60;

      return "$hours hours $minutes minutes";
    } catch (e) {
      return totalHours;
    }
  }


  /// POST TOKEN
  Future<void> _postToken() async {

    /// DEVICE INFO
    final deviceInfo = await DeviceInfoService.getDeviceData();

    var userId = currentUser!.data.first.userid;
    Map<String, String> body = {
      "userid": "$userId",
      "device_token": AppStorage.instance.valueFor(StorageKey.firebaseToken),
      "device_os": deviceInfo["device_os"],
      "device_name": deviceInfo["device_name"],
      "os_version": deviceInfo["os_version"],
    };

    Loader.showLoader();
    homeRepository.postToken(body).then(
          (value) {
        Loader.hideLoader();
        AppUtils.printMessage(
          "Token sent",
        );
      },
      onError: (e) {
        Loader.hideLoader();
        Toast.error(message: e);
      },
    );
  }





  @override
  void onClose() {
    timer?.cancel();

    positionStream?.cancel();

    super.onClose();
  }
}
