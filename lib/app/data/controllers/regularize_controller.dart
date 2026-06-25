/*
 *  Created by Yellow Strawberry LLP on 02/06/26, 5:42 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 02/06/26, 5:42 pm
 *
 */

import 'dart:io';
import 'package:hrms_ys/app/data/repository/regularize_repository.dart';
import 'package:hrms_ys/app/presentation/screens/attendance/regularize_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/utils/app_storage.dart';
import '../../core/utils/utils.dart';
import '../../packages.dart';
import '../models/attendance_list.dart';
import '../models/current_user.dart';
import 'attendance_controller.dart';

class RegularizeController extends GetxController {
  final regularizeRepository = RegularizeRepository();

  ///CURRENT USER
  CurrentUser? currentUser;

  /// REGULARIZE FORM
  final regularizeEmailController = TextEditingController();

  final regularizeReasonController = TextEditingController();

  final regularizeDateController = TextEditingController();

  final checkInController = TextEditingController();

  final checkOutController = TextEditingController();

  String selectedRegularizationType = "Select";

  XFile? selectedImage;

  String? selectedDate;

  var finalAttId = 0;

  AttendanceData? attendanceData;

  @override
  void onInit() {
    super.onInit();

    currentUser = AppStorage.instance.getUserData();

    attendanceData = Get.arguments as AttendanceData?;

    regularizeEmailController.text = currentUser?.data.first.email ?? "";

    if (attendanceData != null) {
      finalAttId = attendanceData!.id ?? 0;

      selectedDate = attendanceData!.attDate ?? "";

      selectedDate = attendanceData!.attDate ?? "";

      final date = DateTime.parse(attendanceData!.attDate!);
      regularizeDateController.text = DateFormat('dd MMM, yyyy').format(date);

      checkInController.text =
          formatTo12Hour(attendanceData!.inTime ?? "");

      checkOutController.text =
      attendanceData!.outTime == "00:00:00"
          ? ""
          : formatTo12Hour(
        attendanceData!.outTime ?? "",
      );
    }
  }

  void changeRegularizationType(String value) {
    selectedRegularizationType = value;

    update();
  }

  Future<void> pickCheckInTime() async {
    final picked = await showTimePicker(
      context: Get.context!,

      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    checkInController.text = picked.format(Get.context!);

    update();
  }

  Future<void> pickCheckOutTime() async {
    final picked = await showTimePicker(
      context: Get.context!,

      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    checkOutController.text = picked.format(Get.context!);

    update();
  }

  String convertTo24Hour(String time) {
    try {
      final date = DateFormat("h:mm a").parse(time);

      return DateFormat("HH:mm:ss").format(date);
    } catch (e) {
      return time;
    }
  }

  String formatTo12Hour(String time) {
    try {
      final date = DateFormat("HH:mm:ss").parse(time);

      return DateFormat("h:mm a").format(date);
    } catch (e) {
      return time;
    }
  }

  Future<void> pickRegularizeImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    selectedImage = image;

    update();
  }

  File? get selectedFile {
    if (selectedImage == null) {
      return null;
    }
    return File(selectedImage!.path);
  }

  bool validateRegularization() {
    if (regularizeEmailController.text.trim().isEmpty) {
      Toast.error(message: "Email is required");

      return false;
    }

    if (selectedDate == null || selectedDate!.isEmpty) {
      Toast.error(message: "Date is required");

      return false;
    }

    if (selectedRegularizationType == "Select") {
      Toast.error(message: "Please select regularization type");

      return false;
    }

    if (checkInController.text.trim().isEmpty) {
      Toast.error(message: "Please select check-in time");

      return false;
    }

    if (checkOutController.text.trim().isEmpty) {
      Toast.error(message: "Please select check-out time");

      return false;
    }

    if (regularizeReasonController.text.trim().isEmpty) {
      Toast.error(message: "Please enter reason");

      return false;
    }

    return true;
  }

  void submitRegularize() {
    if (!validateRegularization()) {
      return;
    }

    final email = regularizeEmailController.text.trim();

    final regType = selectedRegularizationType;

    final inTime = convertTo24Hour(checkInController.text.trim());

    final outTime = convertTo24Hour(checkOutController.text.trim());

    final reason = regularizeReasonController.text.trim();

    Map<String, String> body = {
      'userid': "${currentUser?.data.first.userid ?? 0}",

      'att_id': "$finalAttId",

      'email': email,

      'att_date': "$selectedDate",

      'reg_type': regType,

      'in_time': inTime,

      'out_time': outTime,

      'reason': reason,
    };

    AppUtils.printMessage(body.toString());

    Loader.showLoader();

    /// API CALL HERE
    regularizeRepository
        .submitRegularization(body, selectedFile)
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
            Toast.error(message: e);
          },
        );
  }
}
