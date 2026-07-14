
import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../core/utils/app_storage.dart';
import '../../packages.dart';
import '../models/current_user.dart';
import '../repository/education_repository.dart';

class EducationDetailsController extends GetxController {
  final EducationRepository educationRepository = EducationRepository();

  CurrentUser? currentUser;

  bool isEditing = false;

  /// Controllers for all education entries
  final List<TextEditingController> courseControllers = [];
  final List<TextEditingController> universityControllers = [];
  final List<TextEditingController> gradeControllers = [];
  final List<TextEditingController> startDateControllers = [];
  final List<TextEditingController> endDateControllers = [];

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  void loadCurrentUser() {
    currentUser = AppStorage.instance.getUserData();

    if (currentUser == null) return;

    courseControllers.clear();
    universityControllers.clear();
    gradeControllers.clear();
    startDateControllers.clear();
    endDateControllers.clear();

    for (final education in currentUser!.education) {
      courseControllers.add(
        TextEditingController(text: education.courseName),
      );

      universityControllers.add(
        TextEditingController(text: education.universityName),
      );

      gradeControllers.add(
        TextEditingController(text: education.grade),
      );

      startDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(education.startDate),
        ),
      );

      endDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(education.endDate),
        ),
      );
    }

    update();
  }

  void enableEdit() {
    isEditing = true;
    update();
  }

  void addEducation() {
    courseControllers.add(TextEditingController());
    universityControllers.add(TextEditingController());
    gradeControllers.add(TextEditingController());
    startDateControllers.add(TextEditingController());
    endDateControllers.add(TextEditingController());

    update();
  }

  Future<void> pickStartDate(int index) async {
    DateTime initialDate = DateTime.now();

    if (startDateControllers[index].text.isNotEmpty) {
      try {
        initialDate = DateFormat(
          'dd MMM yyyy',
        ).parse(startDateControllers[index].text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    startDateControllers[index].text =
        DateFormat('dd MMM yyyy').format(picked);

    update();
  }
  Future<void> pickEndDate(int index) async {
    DateTime initialDate = DateTime.now();

    if (endDateControllers[index].text.isNotEmpty) {
      try {
        initialDate = DateFormat(
          'dd MMM yyyy',
        ).parse(endDateControllers[index].text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    endDateControllers[index].text =
        DateFormat('dd MMM yyyy').format(picked);

    update();
  }
  Future<void> updateEducation() async {
    Loader.showLoader();

    try {
      final List<Map<String, dynamic>> educationList = [];
      String formatApiDate(String date) {
        return DateFormat(
          'yyyy-MM-dd',
        ).format(DateFormat('dd MMM yyyy').parse(date));
      }

      for (int i = 0; i < courseControllers.length; i++) {
        educationList.add({
          "id": i < currentUser!.education.length
              ? currentUser!.education[i].id
              : null,
          "userid": currentUser!.data.first.userid,
          "course_name": courseControllers[i].text.trim(),
          "university_name": universityControllers[i].text.trim(),
          "grade": gradeControllers[i].text.trim(),
          "start_date": formatApiDate(startDateControllers[i].text),
          "end_date": formatApiDate(endDateControllers[i].text),
        });      }

      final body = {
        "userid": currentUser!.data.first.userid,
        "first_name": currentUser!.data.first.firstName,
        "last_name": currentUser!.data.first.lastName,
        "email": currentUser!.data.first.email,
        "phone_number": currentUser!.data.first.phoneNumber,
        "status": currentUser!.data.first.status,
        "work_location": currentUser!.data.first.workLocation,
        "user_type": currentUser!.data.first.userType,

        "education": educationList,
      };
      log("Education Request => ${jsonEncode(body)}");

      final response = await educationRepository.updateEducation(body);

      Loader.hideLoader();

      log("Education Response => ${jsonEncode(response)}");

      if (response["success"] == true) {
        isEditing = false;
        update();

        Toast.success(message: response["message"]);
      } else {
        Toast.error(message: response["message"]);
      }
    } catch (e, s) {
      Loader.hideLoader();

      log(e.toString());
      log(s.toString());

      Toast.error(message: e.toString());
    }
  }  @override
  void onClose() {
    for (final controller in courseControllers) {
      controller.dispose();
    }

    for (final controller in universityControllers) {
      controller.dispose();
    }

    for (final controller in gradeControllers) {
      controller.dispose();
    }

    for (final controller in startDateControllers) {
      controller.dispose();
    }

    for (final controller in endDateControllers) {
      controller.dispose();
    }

    super.onClose();
  }
}