import 'dart:convert';
import 'dart:developer';

import 'package:hrms_ys/app/shared/packages.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_storage.dart';
import '../../../data/models/current_user.dart';
import '../data/repositories/project_details_repository.dart';

import 'profile_records_save.dart';

class ProjectDetailsController extends GetxController with ProfileRecordsSave {
  ProjectDetailsController({ProjectDetailsRepository? repository})
    : projectDetailsRepository = repository ?? ProjectDetailsRepository();

  final ProjectDetailsRepository projectDetailsRepository;

  CurrentUser? currentUser;

  bool isEditing = false;
  bool isAddPressed = false;
  bool hasExistingFieldEdits = false;
  int expandedIndex = -1;

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

    for (final controller in titleControllers) {
      controller.dispose();
    }
    titleControllers.clear();
    for (final controller in descriptionControllers) {
      controller.dispose();
    }
    descriptionControllers.clear();
    for (final controller in startDateControllers) {
      controller.dispose();
    }
    startDateControllers.clear();
    for (final controller in endDateControllers) {
      controller.dispose();
    }
    endDateControllers.clear();

    for (final project in currentUser!.projects) {
      final titleController = TextEditingController(text: project.title);

      titleController.addListener(() {
        update();
      });

      titleControllers.add(titleController);

      descriptionControllers.add(
        TextEditingController(text: project.description),
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
    if (isEditing || isSavingRecords) return;
    resetRecordSaveFeedback();
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

  /// Adds a blank field-set to the UI only (no API call).
  /// Mirrors EducationController.newEducation().
  void newProject() {
    if (!isEditing || isSavingRecords) return;
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
    final response = await projectDetailsRepository.getUser();
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw const FormatException('Unable to refresh profile records');
    }
    await AppStorage.instance.setUserData(CurrentUser.fromJson(response));
    loadCurrentUser();
  }

  Future<void> deleteProject(int index) async {
    if (isSavingRecords || hasSavedRows) return;
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

    startDateControllers[index].text = DateFormat('dd MMM yyyy').format(picked);

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

    endDateControllers[index].text = DateFormat('dd MMM yyyy').format(picked);

    update();
  }

  /// New (not-yet-persisted) project field can be removed locally.
  void removeNewProject(int index) {
    final key = titleControllers[index];
    if (isSavingRecords || recordIsLocked(key)) return;
    removeRecordErrors(key);
    if (index < currentUser!.projects.length) return;

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

    isAddPressed = titleControllers.length > currentUser!.projects.length;
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

  Future<void> cancelEdit() async {
    if (!isEditing || isSavingRecords) return;
    await discardRecordChanges(
      refresh: refreshCurrentUser,
      finish: () {
        isEditing = false;
        isAddPressed = false;
        hasExistingFieldEdits = false;
        loadCurrentUser();
      },
    );
  }

  @override
  Map<String, ProfileFieldRule> get recordFieldRules => const {
    'title': (label: 'project title', min: 2, max: 100),
    'description': (label: 'project description', min: 2, max: 100),
  };

  @override
  List<ProfileRecordDraft> get recordDrafts {
    final existing = currentUser?.projects ?? [];
    return [
      for (var index = 0; index < titleControllers.length; index++)
        (
          key: titleControllers[index],
          original: index < existing.length ? existing[index].toJson() : null,
          fields: {
            'title': titleControllers[index].text.trim(),
            'description': descriptionControllers[index].text.trim(),
            'start_date': startDateControllers[index].text.trim(),
            'end_date': endDateControllers[index].text.trim(),
          },
        ),
    ];
  }

  Future<void> saveProjects() async {
    if (!isEditing) return;
    await saveRecordChanges(
      userId: currentUser?.data.firstOrNull?.userid,
      add: projectDetailsRepository.addProject,
      edit: projectDetailsRepository.updateProjects,
      refresh: refreshCurrentUser,
      finish: () {
        isEditing = false;
        isAddPressed = false;
        hasExistingFieldEdits = false;
      },
      successMessage: 'Project details saved.',
    );
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
