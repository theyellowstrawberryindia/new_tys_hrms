import 'dart:convert';
import 'dart:developer';

import '../../core/utils/app_storage.dart';
import '../../packages.dart';
import '../models/current_user.dart';
import '../repository/privacy_policy_repository.dart';

class PolicyController extends GetxController {
  final PolicyRepository policyRepository = PolicyRepository();

  CurrentUser? currentUser;

  bool isLoading = false;
  bool isCheckboxChecked = false;

  Policy? get policy =>
      currentUser != null && currentUser!.policies.isNotEmpty
          ? currentUser!.policies.first
          : null;

  /// Single source of truth — reads straight from the backend-reported
  /// value (0/1). Never locally overridden to true without a fresh fetch.
  bool get isPolicyAccepted =>
      currentUser != null &&
          currentUser!.professionalDetails.isNotEmpty &&
          currentUser!.professionalDetails.first.isPolicyAccepted == 1;

  @override
  void onInit() {
    super.onInit();
    currentUser = AppStorage.instance.getUserData();
    fetchPolicy();
  }

  Future<void> fetchPolicy() async {
    isLoading = true;
    update();

    try {
      final response = await policyRepository.getPolicy();

      log("Get Policy Response => ${jsonEncode(response)}");

      if (response["status"] == true) {
        final List data = response["data"] ?? [];

        final fetchedPolicies = data
            .map((e) => Policy.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (currentUser != null) {
          currentUser!.policies = fetchedPolicies;
          await AppStorage.instance.setUserData(currentUser!);
        }
      } else {
        throw Exception(response["message"] ?? "Failed to load policy.");
      }
    } catch (e, s) {
      log("Get Policy Error => $e");
      log(s.toString());

      Toast.error(message: "Unable to load policy. Please try again.");
    } finally {
      isLoading = false;
      update();
    }
  }

  /// No-op once accepted — checkbox can never be un-ticked after
  /// backend confirmation, since isPolicyAccepted becomes the sole gate.
  void toggleCheckbox(bool value) {
    if (isPolicyAccepted) return;

    isCheckboxChecked = value;
    update();
  }

  Future<bool> acceptPolicy() async {
    if (isPolicyAccepted) return true;
    if (!isCheckboxChecked) return false;

    Loader.showLoader();

    try {
      final body = {
        "userid": currentUser!.data.first.userid.toString(),
        "is_policy_accepted": true,
      };

      final response = await policyRepository.acceptPolicy(body);

      if (response["status"] != true) {
        throw Exception(
          response["message"] ?? "Failed to accept policy.",
        );
      }

      if (currentUser != null &&
          currentUser!.professionalDetails.isNotEmpty) {
        currentUser!.professionalDetails.first.isPolicyAccepted = 1;

        await AppStorage.instance.setUserData(currentUser!);
      }

      Loader.hideLoader();

      Toast.success(
        message:
        response["message"] ??
            "Policy acceptance updated successfully",
      );

      update();

      return true;
    } catch (e, s) {
      log("Accept Policy Error => $e");
      log(s.toString());

      Loader.hideLoader();

      Toast.error(message: e.toString());

      return false;
    }
  }
}