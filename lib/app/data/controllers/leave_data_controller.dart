
import 'package:flutter/scheduler.dart';
import '../../packages.dart';
import '../models/attendance_list.dart';
import '../models/leave_data.dart';
import '../repository/leave_data_repository.dart';

class LeaveDataController extends GetxController {
  final LeaveDataRepository leaveDataRepository = LeaveDataRepository();

  final RxnString errorMessage = RxnString();

  final RxList<LeaveTerm> terms = <LeaveTerm>[].obs;
  final Rx<LeaveTerm?> selectedTerm = Rx<LeaveTerm?>(null);

  final RxList<AttendanceData> rows = <AttendanceData>[].obs;

  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();
    initLeaveData();
  }

  void initLeaveData() {
    if (_initialized) return;
    _initialized = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      loadTerms();
    });
  }

  Future<void> loadTerms({int? year}) async {
    errorMessage.value = null;

    try {
      Loader.showLoader();

      final json = await leaveDataRepository.getLeaveTermStatus(
        year: year ?? DateTime.now().year,
      );
      final response = LeaveTermStatusResponse.fromJson(json);
      terms.assignAll(response.data);

      if (terms.isNotEmpty) {
        selectedTerm.value = terms.first;
        await _fetchTermDetails(terms.first.id);
      } else {
        rows.clear();
        errorMessage.value = 'No leave terms found.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load leave terms: $e';
    } finally {
      Loader.hideLoader();
    }
  }

  Future<void> loadTermDetails(int termId) async {
    errorMessage.value = null;
    try {
      Loader.showLoader();
      await _fetchTermDetails(termId);
    } finally {
      Loader.hideLoader();
    }
  }

  Future<void> _fetchTermDetails(int termId) async {
    try {
      final json = await leaveDataRepository.getLeaveTermDetails(termId);
      final response = AttendanceListResponse.fromJson(json);
      rows.assignAll(response.data ?? []);
      if (rows.isEmpty) {
        errorMessage.value = 'No leave data for this term.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load leave data: $e';
    }
  }

  void onTermChanged(LeaveTerm? term) {
    if (term == null || term.id == selectedTerm.value?.id) return;
    selectedTerm.value = term;
    loadTermDetails(term.id);
  }

  void onFilterPressed() {
    final term = selectedTerm.value;
    if (term != null) loadTermDetails(term.id);
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case "Present":
        return AppColor.kSuccessColor;
      case "Late":
        return Colors.amber;
      case "Absent":
        return AppColor.kErrorColor;
      case "Leave":
        return Colors.blue;
      case "Halfday":
        return Colors.purple;
      default:
        return AppColor.kGrayTextColor;
    }
  }
}