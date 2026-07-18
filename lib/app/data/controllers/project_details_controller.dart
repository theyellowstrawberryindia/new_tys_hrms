import 'dart:convert';
import 'dart:developer';

import 'package:hrms_ys/app/packages.dart';
import 'package:intl/intl.dart';

import '../../core/utils/app_storage.dart';
import '../models/current_user.dart';
import '../repository/project_details_repository.dart';

class ProjectDetailsController extends GetxController {
  final ProjectDetailsRepository projectDetailsRepository =
  ProjectDetailsRepository();

  CurrentUser? currentUser;

  bool isEditing = false;
  bool isAddPressed = false;
  bool hasExistingFieldEdits = false;
  int expandedIndex = -1;
  bool showValidationErrors = false;

  final List<TextEditingController> titleControllers = [];
  final List<TextEditingController> descriptionControllers = [];
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

    titleControllers.clear();
    descriptionControllers.clear();
    startDateControllers.clear();
    endDateControllers.clear();

    for (final project in currentUser!.projects) {
      final titleController = TextEditingController(
        text: project.title,
      );

      titleController.addListener(() {
        update();
      });

      titleControllers.add(titleController);

      descriptionControllers.add(
        TextEditingController(
          text: project.description,
        ),
      );

      startDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(project.startDate),
        ),
      );

      endDateControllers.add(
        TextEditingController(
          text: DateFormat('dd MMM yyyy').format(project.endDate),
        ),
      );
    }

    update();
  }

  void enableEdit() {
    isEditing = true;
    isAddPressed = false;
    hasExistingFieldEdits = false;

    final existingCount = currentUser!.projects.length;

    for (int i = 0; i < existingCount; i++) {
      titleControllers[i].addListener(_markExistingFieldEdited);
      descriptionControllers[i].addListener(_markExistingFieldEdited);
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
    final existingCount = currentUser!.projects.length;

    for (int i = 0; i < existingCount; i++) {
      titleControllers[i].removeListener(_markExistingFieldEdited);
      descriptionControllers[i].removeListener(_markExistingFieldEdited);
      startDateControllers[i].removeListener(_markExistingFieldEdited);
      endDateControllers[i].removeListener(_markExistingFieldEdited);
    }
  }
  /// Adds a blank field-set to the UI only (no API call).
  /// Mirrors EducationController.newEducation().
  void newProject() {
    showValidationErrors = false;
    isAddPressed = true;

    final controller = TextEditingController();

    controller.addListener(() {
      update();
    });

    titleControllers.add(controller);
    descriptionControllers.add(TextEditingController());
    startDateControllers.add(TextEditingController());
    endDateControllers.add(TextEditingController());

    expandedIndex = titleControllers.length - 1;

    update();
  }

  Future<void> refreshCurrentUser() async {
    try {
      final response = await projectDetailsRepository.getUser();

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

  bool validateProjectFields() {
    for (int i = 0; i < titleControllers.length; i++) {
      final title = titleControllers[i].text.trim();
      final description = descriptionControllers[i].text.trim();
      final startDate = startDateControllers[i].text.trim();
      final endDate = endDateControllers[i].text.trim();

      if (title.length < 2 || title.length > 100) return false;
      if (description.length < 2 || description.length > 100) return false;
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

  /// Only newly added (not-yet-persisted) project entries
  Future<void> addProject() async {
    try {
      for (
      int i = currentUser!.projects.length;
      i < titleControllers.length;
      i++
      ) {
        final body = {
          "userid": currentUser!.data.first.userid.toString(),
          "title": titleControllers[i].text.trim(),
          "description": descriptionControllers[i].text.trim(),
          "start_date": _formatApiDate(startDateControllers[i].text),
          "end_date": _formatApiDate(endDateControllers[i].text),
        };

        log("Add Project Request => ${jsonEncode(body)}");

        final response = await projectDetailsRepository.addProject(body);

        log("Add Project Response => ${jsonEncode(response)}");

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

  /// Only existing (already persisted) project entries
  Future<void> updateProjects() async {
    try {
      for (int i = 0; i < currentUser!.projects.length; i++) {
        final body = {
          "id": currentUser!.projects[i].id,
          "userid": currentUser!.data.first.userid.toString(),
          "title": titleControllers[i].text.trim(),
          "description": descriptionControllers[i].text.trim(),
          "start_date": _formatApiDate(startDateControllers[i].text),
          "end_date": _formatApiDate(endDateControllers[i].text),
        };

        log("Update Project Request => ${jsonEncode(body)}");

        final response = await projectDetailsRepository.updateProjects(body);

        log("Update Project Response => ${jsonEncode(response)}");

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

  Future<void> deleteProject(int index) async {
    Loader.showLoader();

    try {
      final body = {
        "id": currentUser!.projects[index].id,
        "userid": currentUser!.data.first.userid.toString(),
      };

      log("Delete Project Request => ${jsonEncode(body)}");

      final response = await projectDetailsRepository.deleteProject(body);

      log("Delete Project Response => ${jsonEncode(response)}");

      if (response["success"] != true) {
        throw Exception(response["message"]);
      }

      await refreshCurrentUser();

      Loader.hideLoader();

      Toast.success(message: "Project deleted successfully.");
    } catch (e, s) {
      log("Delete Project Error => $e");
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

  /// New (not-yet-persisted) project field can be removed locally.
  void removeNewProject(int index) {
    if (index < currentUser!.projects.length) return;

    showValidationErrors = false;

    titleControllers[index].dispose();
    descriptionControllers[index].dispose();
    startDateControllers[index].dispose();
    endDateControllers[index].dispose();

    titleControllers.removeAt(index);
    descriptionControllers.removeAt(index);
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
    isAddPressed = false;
    hasExistingFieldEdits = false;
    showValidationErrors = false;
    _removeExistingFieldListeners();

    loadCurrentUser();

    update();
  }

  Future<void> saveProjects() async {
    Loader.showLoader();

    try {
      await updateProjects();

      await addProject();

      await refreshCurrentUser();

      _removeExistingFieldListeners();
      isEditing = false;
      isAddPressed = false;
      hasExistingFieldEdits = false;

      update();

      Loader.hideLoader();

      Toast.success(message: "Project details updated successfully.");
    } catch (e, s) {
      log("Save Project Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(message: e.toString());
    }
  }

  @override
  void onClose() {
    for (final controller in titleControllers) {
      controller.dispose();
    }

    for (final controller in descriptionControllers) {
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