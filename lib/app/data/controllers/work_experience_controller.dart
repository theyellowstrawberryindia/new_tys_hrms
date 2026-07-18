import 'dart:convert';
import 'dart:developer';

import 'package:hrms_ys/app/packages.dart';
import 'package:intl/intl.dart';

import '../../core/utils/app_storage.dart';
import '../models/current_user.dart';
import '../repository/work_experience_repository.dart';

class WorkExperienceController extends GetxController {
  final WorkExperienceRepository workExperienceRepository =
  WorkExperienceRepository();

  CurrentUser? currentUser;

  bool isEditing = false;
  int expandedIndex = -1;
  bool showValidationErrors = false;

  final List<TextEditingController> companyControllers = [];
  final List<TextEditingController> designationControllers = [];
  final List<TextEditingController> expControllers = [];
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

    companyControllers.clear();
    designationControllers.clear();
    expControllers.clear();
    startDateControllers.clear();
    endDateControllers.clear();

    for (final workExp in currentUser!.workExperience) {
      final companyController = TextEditingController(
        text: workExp.componyName,
      );

      companyController.addListener(() {
        update();
      });

      companyControllers.add(companyController);

      designationControllers.add(
        TextEditingController(text: workExp.designation),
      );

      expControllers.add(
        TextEditingController(text: workExp.exp),
      );

      startDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(workExp.startDate),
        ),
      );

      endDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(workExp.endDate),
        ),
      );
    }

    update();
  }

  void enableEdit() {
    isEditing = true;
    update();
  }

  /// Adds a blank field-set to the UI only (no API call).
  void newWorkExperience() {
    showValidationErrors = false;

    final controller = TextEditingController();

    controller.addListener(() {
      update();
    });

    companyControllers.add(controller);
    designationControllers.add(TextEditingController());
    expControllers.add(TextEditingController());
    startDateControllers.add(TextEditingController());
    endDateControllers.add(TextEditingController());

    expandedIndex = companyControllers.length - 1;

    update();
  }

  Future<void> refreshCurrentUser() async {
    try {
      final response = await workExperienceRepository.getUser();

      log("Refresh Current User Response => ${jsonEncode(response)}");

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

  bool validateWorkExperienceFields() {
    for (int i = 0; i < companyControllers.length; i++) {
      final company = companyControllers[i].text.trim();
      final designation = designationControllers[i].text.trim();
      final exp = expControllers[i].text.trim();
      final startDate = startDateControllers[i].text.trim();
      final endDate = endDateControllers[i].text.trim();

      if (company.length < 2 || company.length > 100) return false;
      if (designation.length < 2 || designation.length > 100) return false;
      if (exp.isEmpty || exp.length > 50) return false;
      if (startDate.isEmpty) return false;
      if (endDate.isEmpty) return false;
    }

    return true;
  }

  String _formatApiDate(String date) {
    return DateFormat('yyyy-MM-dd').format(
      DateFormat('dd MMM yyyy').parse(date),
    );
  }

  /// Only newly added (not-yet-persisted) entries
  Future<void> addWorkExperience() async {
    try {
      for (
      int i = currentUser!.workExperience.length;
      i < companyControllers.length;
      i++
      ) {
        final body = {
          "userid": currentUser!.data.first.userid.toString(),
          "compony_name": companyControllers[i].text.trim(),
          "designation": designationControllers[i].text.trim(),
          "exp": expControllers[i].text.trim(),
          "start_date": _formatApiDate(startDateControllers[i].text),
          "end_date": _formatApiDate(endDateControllers[i].text),
        };

        log("Add Work Experience Request => ${jsonEncode(body)}");

        final response =
        await workExperienceRepository.addWorkExperience(body);

        log("Add Work Experience Response => ${jsonEncode(response)}");

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

  /// Only existing (already persisted) entries
  Future<void> updateWorkExperiences() async {
    try {
      for (int i = 0; i < currentUser!.workExperience.length; i++) {
        final body = {
          "id": currentUser!.workExperience[i].id,
          "userid": currentUser!.data.first.userid.toString(),
          "compony_name": companyControllers[i].text.trim(),
          "designation": designationControllers[i].text.trim(),
          "exp": expControllers[i].text.trim(),
          "start_date": _formatApiDate(startDateControllers[i].text),
          "end_date": _formatApiDate(endDateControllers[i].text),
        };

        log("Update Work Experience Request => ${jsonEncode(body)}");

        final response =
        await workExperienceRepository.updateWorkExperience(body);

        log("Update Work Experience Response => ${jsonEncode(response)}");

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

  Future<void> deleteWorkExperience(int index) async {
    Loader.showLoader();

    try {
      final body = {
        "id": currentUser!.workExperience[index].id,
        "userid": currentUser!.data.first.userid.toString(),
      };

      log("Delete Work Experience Request => ${jsonEncode(body)}");

      final response =
      await workExperienceRepository.deleteWorkExperience(body);

      log("Delete Work Experience Response => ${jsonEncode(response)}");

      if (response["success"] != true) {
        throw Exception(response["message"]);
      }

      await refreshCurrentUser();

      Loader.hideLoader();

      Toast.success(message: "Work experience deleted successfully.");
    } catch (e, s) {
      log("Delete Work Experience Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(message: e.toString());
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

  /// New (not-yet-persisted) entry can be removed locally.
  void removeNewWorkExperience(int index) {
    if (index < currentUser!.workExperience.length) return;

    showValidationErrors = false;

    companyControllers[index].dispose();
    designationControllers[index].dispose();
    expControllers[index].dispose();
    startDateControllers[index].dispose();
    endDateControllers[index].dispose();

    companyControllers.removeAt(index);
    designationControllers.removeAt(index);
    expControllers.removeAt(index);
    startDateControllers.removeAt(index);
    endDateControllers.removeAt(index);

    if (expandedIndex == index) {
      expandedIndex = -1;
    } else if (expandedIndex > index) {
      expandedIndex -= 1;
    }

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
    showValidationErrors = false;

    loadCurrentUser();

    update();
  }

  Future<void> saveWorkExperience() async {
    Loader.showLoader();

    try {
      await updateWorkExperiences();

      await addWorkExperience();

      await refreshCurrentUser();

      isEditing = false;

      update();

      Loader.hideLoader();

      Toast.success(message: "Work experience updated successfully.");
    } catch (e, s) {
      log("Save Work Experience Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(message: e.toString());
    }
  }

  @override
  void onClose() {
    for (final controller in companyControllers) {
      controller.dispose();
    }
    for (final controller in designationControllers) {
      controller.dispose();
    }
    for (final controller in expControllers) {
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