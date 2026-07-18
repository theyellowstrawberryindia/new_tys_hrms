
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
  bool showValidationErrors = false;

  bool isEditing = false;
  bool isAddPressed = false;
  bool hasExistingFieldEdits = false;
  int expandedIndex = -1;

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

      final courseController = TextEditingController(
        text: education.courseName,
      );

      courseController.addListener(() {
        update();
      });

      courseControllers.add(courseController);

      universityControllers.add(
        TextEditingController(
          text: education.universityName,
        ),
      );

      gradeControllers.add(
        TextEditingController(
          text: education.grade,
        ),
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
    isAddPressed = false;
    hasExistingFieldEdits = false;

    final existingCount = currentUser!.education.length;

    for (int i = 0; i < existingCount; i++) {
      courseControllers[i].addListener(_markExistingFieldEdited);
      universityControllers[i].addListener(_markExistingFieldEdited);
      gradeControllers[i].addListener(_markExistingFieldEdited);
      startDateControllers[i].addListener(_markExistingFieldEdited);
      endDateControllers[i].addListener(_markExistingFieldEdited);
    }

    update();
  }

  void _markExistingFieldEdited() {
    if (!hasExistingFieldEdits) {
      hasExistingFieldEdits = true;
      update();
    }
  }

  void _removeExistingFieldListeners() {
    final existingCount = currentUser!.education.length;

    for (int i = 0; i < existingCount; i++) {
      courseControllers[i].removeListener(_markExistingFieldEdited);
      universityControllers[i].removeListener(_markExistingFieldEdited);
      gradeControllers[i].removeListener(_markExistingFieldEdited);
      startDateControllers[i].removeListener(_markExistingFieldEdited);
      endDateControllers[i].removeListener(_markExistingFieldEdited);
    }
  }
  void newEducation() {
    showValidationErrors = false;
    isAddPressed = true;

    final controller = TextEditingController();

    controller.addListener(() {
      update();
    });

    courseControllers.add(controller);
    universityControllers.add(TextEditingController());
    gradeControllers.add(TextEditingController());
    startDateControllers.add(TextEditingController());
    endDateControllers.add(TextEditingController());

    expandedIndex = courseControllers.length - 1;

    update();
  }

  Future<void> refreshCurrentUser() async {
    try {
      final response = await educationRepository.getUser();

      log(
        "Refresh Current User Response => ${jsonEncode(response)}",
      );

      if (response["success"] == true) {
        final CurrentUser updatedUser = CurrentUser.fromJson(
          Map<String, dynamic>.from(response),
        );

        await AppStorage.instance.setUserData(updatedUser);

        currentUser = updatedUser;

        loadCurrentUser();
      } else {
        throw Exception(
          response["message"] ?? "Failed to refresh user details.",
        );
      }
    } catch (e, s) {
      log("Refresh Current User Error => $e");
      log(s.toString());

      rethrow;
    }
  }

  Future<void> addEducation() async {
    try {
      String formatApiDate(String date) {
        return DateFormat(
          'yyyy-MM-dd',
        ).format(
          DateFormat('dd MMM yyyy').parse(date),
        );
      }

      // Only newly added education entries
      for (
      int i = currentUser!.education.length;
      i < courseControllers.length;
      i++
      ) {
        final body = {
          "userid": currentUser!.data.first.userid.toString(),
          "university_name": universityControllers[i].text.trim(),
          "course_name": courseControllers[i].text.trim(),
          "start_date": formatApiDate(startDateControllers[i].text),
          "end_date": formatApiDate(endDateControllers[i].text),
          "grade": gradeControllers[i].text.trim(),
        };

        log("Add Education Request => ${jsonEncode(body)}");

        final response = await educationRepository.addEducation(body);

        log("Add Education Response => ${jsonEncode(response)}");

        if (response["success"] != true) {
          throw Exception(response["message"]);
        }
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      rethrow;
    }
  }


  Future<void> deleteEducation(int index) async {
    Loader.showLoader();

    try {
      final body = {
        "id": currentUser!.education[index].id,
        "userid": currentUser!.data.first.userid.toString(),
      };

      log("Delete Education Request => ${jsonEncode(body)}");

      final response = await educationRepository.deleteEducation(body);

      log("Delete Education Response => ${jsonEncode(response)}");

      if (response["success"] != true) {
        throw Exception(response["message"]);
      }

      // Re-fetch from API and rebuild all controller lists cleanly —
      // same pattern saveEducation() already uses, avoids manual
      // dispose/removeAt index bookkeeping.
      await refreshCurrentUser();

      Loader.hideLoader();

      Toast.success(
        message: "Education deleted successfully.",
      );
    } catch (e, s) {
      log("Delete Education Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(
        message: e.toString(),
      );
    }
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
    try {
      String formatApiDate(String date) {
        return DateFormat(
          'yyyy-MM-dd',
        ).format(
          DateFormat('dd MMM yyyy').parse(date),
        );
      }

      // Only update existing education entries
      for (int i = 0; i < currentUser!.education.length; i++) {
        final body = {
          "id": currentUser!.education[i].id,
          "userid": currentUser!.data.first.userid.toString(),
          "university_name": universityControllers[i].text.trim(),
          "course_name": courseControllers[i].text.trim(),
          "start_date": formatApiDate(startDateControllers[i].text),
          "end_date": formatApiDate(endDateControllers[i].text),
          "grade": gradeControllers[i].text.trim(),
        };

        log("Update Education Request => ${jsonEncode(body)}");

        final response = await educationRepository.updateEducation(body);

        log("Update Education Response => ${jsonEncode(response)}");

        if (response["success"] != true) {
          throw Exception(response["message"]);
        }
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      rethrow;
    }
  }

  ///New Education field can be removed not existing
  void removeNewEducation(int index) {
    showValidationErrors = false;

    if (index < currentUser!.education.length) return;

    courseControllers[index].dispose();
    universityControllers[index].dispose();
    gradeControllers[index].dispose();
    startDateControllers[index].dispose();
    endDateControllers[index].dispose();

    courseControllers.removeAt(index);
    universityControllers.removeAt(index);
    gradeControllers.removeAt(index);
    startDateControllers.removeAt(index);
    endDateControllers.removeAt(index);

    update();
  }


  void toggleExpansion(int index, bool expanded) {
    if (expanded) {
      expandedIndex = index;
    } else if (expandedIndex == index) {
      expandedIndex = -1;
    }

    update();
  }
  void cancelEdit() {
    if (!isEditing) return;

    isEditing = false;
    isAddPressed = false;
    hasExistingFieldEdits = false;
    showValidationErrors = false;
    _removeExistingFieldListeners();

    loadCurrentUser();

    update();
  }
  Future<void> saveEducation() async {
    Loader.showLoader();

    try {
      await updateEducation();

      await addEducation();

      await refreshCurrentUser();

      _removeExistingFieldListeners();
      isEditing = false;
      isAddPressed = false;
      hasExistingFieldEdits = false;

      update();

      Loader.hideLoader();

      Toast.success(message: "Education updated successfully.");
    } catch (e, s) {
      log("Save Education Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(message: e.toString());
    }
  }

  bool validateEducationFields() {
    for (int i = 0; i < courseControllers.length; i++) {
      final course = courseControllers[i].text.trim();
      final university = universityControllers[i].text.trim();
      final startDate = startDateControllers[i].text.trim();
      final endDate = endDateControllers[i].text.trim();

      if (course.length < 2 || course.length > 100) return false;
      if (university.length < 2 || university.length > 100) return false;
      if (startDate.isEmpty) return false;
      if (endDate.isEmpty) return false;
    }

    return true;
  }

  @override
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