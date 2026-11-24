import 'dart:convert';
import 'dart:developer';

import 'package:hrms_ys/app/shared/packages.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_storage.dart';
import '../../../data/models/current_user.dart';
import '../data/repositories/work_experience_repository.dart';

import 'profile_records_save.dart';

class WorkExperienceController extends GetxController with ProfileRecordsSave {
  WorkExperienceController({WorkExperienceRepository? repository})
    : workExperienceRepository = repository ?? WorkExperienceRepository();

  final WorkExperienceRepository workExperienceRepository;

  CurrentUser? currentUser;

  bool isEditing = false;
  bool hasExistingFieldEdits = false;
  int expandedIndex = -1;
  bool isAddPressed = false;

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

    for (final controller in companyControllers) {
      controller.dispose();
    }
    companyControllers.clear();
    for (final controller in designationControllers) {
      controller.dispose();
    }
    designationControllers.clear();
    for (final controller in expControllers) {
      controller.dispose();
    }
    expControllers.clear();
    for (final controller in startDateControllers) {
      controller.dispose();
    }
    startDateControllers.clear();
    for (final controller in endDateControllers) {
      controller.dispose();
    }
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

      expControllers.add(TextEditingController(text: workExp.exp));

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
    if (isEditing || isSavingRecords) return;
    resetRecordSaveFeedback();
    isEditing = true;
    isAddPressed = false;
    hasExistingFieldEdits = false;

    final existingCount = currentUser!.workExperience.length;

    for (int i = 0; i < existingCount; i++) {
      companyControllers[i].addListener(_markExistingFieldEdited);
      designationControllers[i].addListener(_markExistingFieldEdited);
      expControllers[i].addListener(_markExistingFieldEdited);
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
  void newWorkExperience() {
    if (!isEditing || isSavingRecords) return;
    isAddPressed = true;

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
    final response = await workExperienceRepository.getUser();
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw const FormatException('Unable to refresh profile records');
    }
    await AppStorage.instance.setUserData(CurrentUser.fromJson(response));
    loadCurrentUser();
  }

  Future<void> deleteWorkExperience(int index) async {
    if (isSavingRecords || hasSavedRows) return;
    Loader.showLoader();

    try {
      final body = {
        "id": currentUser!.workExperience[index].id,
        "userid": currentUser!.data.first.userid.toString(),
      };

      log("Delete Work Experience Request => ${jsonEncode(body)}");

      final response = await workExperienceRepository.deleteWorkExperience(
        body,
      );

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

  /// New (not-yet-persisted) entry can be removed locally.
  void removeNewWorkExperience(int index) {
    final key = companyControllers[index];
    if (isSavingRecords || recordIsLocked(key)) return;
    removeRecordErrors(key);
    if (index < currentUser!.workExperience.length) return;

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

    isAddPressed =
        companyControllers.length > currentUser!.workExperience.length;
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

  // void _markExistingFieldEdited() {
  //   if (!hasExistingFieldEdits) {
  //     hasExistingFieldEdits = true;
  //     update();
  //   }
  // }

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
    'compony_name': (label: 'company name', min: 2, max: 100),
    'designation': (label: 'designation', min: 2, max: 100),
    'exp': (label: 'experience', min: 1, max: 50),
  };

  @override
  List<ProfileRecordDraft> get recordDrafts {
    final existing = currentUser?.workExperience ?? [];
    return [
      for (var index = 0; index < companyControllers.length; index++)
        (
          key: companyControllers[index],
          original: index < existing.length ? existing[index].toJson() : null,
          fields: {
            'compony_name': companyControllers[index].text.trim(),
            'designation': designationControllers[index].text.trim(),
            'exp': expControllers[index].text.trim(),
            'start_date': startDateControllers[index].text.trim(),
            'end_date': endDateControllers[index].text.trim(),
          },
        ),
    ];
  }

  Future<void> saveWorkExperience() async {
    if (!isEditing) return;
    await saveRecordChanges(
      userId: currentUser?.data.firstOrNull?.userid,
      add: workExperienceRepository.addWorkExperience,
      edit: workExperienceRepository.updateWorkExperience,
      refresh: refreshCurrentUser,
      finish: () {
        isEditing = false;
        isAddPressed = false;
        hasExistingFieldEdits = false;
      },
      successMessage: 'Work experience saved.',
    );
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
    isAddPressed = false;

    super.onClose();
  }
}
