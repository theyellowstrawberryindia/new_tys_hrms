import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../core/utils/app_storage.dart';
import '../../../shared/packages.dart';
import '../../../data/models/current_user.dart';
import '../data/repositories/education_repository.dart';

import 'profile_records_save.dart';

class EducationDetailsController extends GetxController
    with ProfileRecordsSave {
  EducationDetailsController({EducationRepository? repository})
    : educationRepository = repository ?? EducationRepository();

  final EducationRepository educationRepository;

  CurrentUser? currentUser;

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

    for (final controller in courseControllers) {
      controller.dispose();
    }
    courseControllers.clear();
    for (final controller in universityControllers) {
      controller.dispose();
    }
    universityControllers.clear();
    for (final controller in gradeControllers) {
      controller.dispose();
    }
    gradeControllers.clear();
    for (final controller in startDateControllers) {
      controller.dispose();
    }
    startDateControllers.clear();
    for (final controller in endDateControllers) {
      controller.dispose();
    }
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
        TextEditingController(text: education.universityName),
      );

      gradeControllers.add(TextEditingController(text: education.grade));

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
    if (isEditing || isSavingRecords) return;
    resetRecordSaveFeedback();
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

  void newEducation() {
    if (!isEditing || isSavingRecords) return;
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
    final response = await educationRepository.getUser();
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw const FormatException('Unable to refresh profile records');
    }
    await AppStorage.instance.setUserData(CurrentUser.fromJson(response));
    loadCurrentUser();
  }

  Future<void> deleteEducation(int index) async {
    if (isSavingRecords || hasSavedRows) return;
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

      Toast.success(message: "Education deleted successfully.");
    } catch (e, s) {
      log("Delete Education Error => $e");
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

  ///New Education field can be removed not existing
  void removeNewEducation(int index) {
    final key = courseControllers[index];
    if (isSavingRecords || recordIsLocked(key)) return;
    removeRecordErrors(key);

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

    if (expandedIndex == index) {
      expandedIndex = -1;
    } else if (expandedIndex > index) {
      expandedIndex -= 1;
    }

    isAddPressed = courseControllers.length > currentUser!.education.length;
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
    'course_name': (label: 'course name', min: 2, max: 100),
    'university_name': (label: 'university', min: 2, max: 100),
  };

  @override
  List<ProfileRecordDraft> get recordDrafts {
    final existing = currentUser?.education ?? [];
    return [
      for (var index = 0; index < courseControllers.length; index++)
        (
          key: courseControllers[index],
          original: index < existing.length ? existing[index].toJson() : null,
          fields: {
            'course_name': courseControllers[index].text.trim(),
            'university_name': universityControllers[index].text.trim(),
            'grade': gradeControllers[index].text.trim(),
            'start_date': startDateControllers[index].text.trim(),
            'end_date': endDateControllers[index].text.trim(),
          },
        ),
    ];
  }

  Future<void> saveEducation() async {
    if (!isEditing) return;
    await saveRecordChanges(
      userId: currentUser?.data.firstOrNull?.userid,
      add: educationRepository.addEducation,
      edit: educationRepository.updateEducation,
      refresh: refreshCurrentUser,
      finish: () {
        isEditing = false;
        isAddPressed = false;
        hasExistingFieldEdits = false;
      },
      successMessage: 'Education details saved.',
    );
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
