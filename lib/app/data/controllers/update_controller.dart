/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:37 pm
 *
 */

import '../../core/utils/utils.dart';
import '../../packages.dart';
import '../../presentation/screens/update/approval_detail_screen.dart';
import '../models/HolidayModel.dart';
import '../models/UpdateItemModel.dart';
import '../repository/update_repository.dart';

class UpdateController extends GetxController {
  final updateRepository = UpdateRepository();

  int selectedTab = 0;

  List<HolidayData> holidayList = [];

  List<UpdateItem> approvalList = [];

  List<UpdateItem> notificationList = [];

  final PageController pageController = PageController();


  void changeTab(int index) {
    selectedTab = index;

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    update();
  }

  void onPageChanged(int index) {
    selectedTab = index;
    update();
  }


  @override
  void onReady() {
    super.onReady();

    getApprovals();

    getNotifications();

    getHolidays();
  }

  Future<void> refreshUpdates() async {
    try {
      approvalList.clear();
      holidayList.clear();
      notificationList.clear();

      update();

      await Future.wait([
        getApprovals(),
        getHolidays(),
        getNotifications(),
      ]);
    } catch (e) {
      AppUtils.printMessage("Refresh Error => $e");
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return AppColor.kSuccessColor;

      case "rejected":
        return AppColor.kErrorColor;

      default:
        return AppColor.kPrimaryColor;
    }
  }

  void openNotificationDetail(dynamic item) {
    Get.to(
          () => ApprovalDetailScreen(
        item: item,
      ),
    );
  }

  Future<void> getApprovals() async {
    Loader.showLoader();

    updateRepository.getApprovals().then(
      (value) {
        Loader.hideLoader();

        approvalList = (value['data'] as List)
            .map((e) => UpdateItem.fromJson(e))
            .toList();

        update();
      },
      onError: (e) {
        Loader.hideLoader();

        Toast.error(message: e);
      },
    );
  }

  Future<void> getNotifications() async {
    Loader.showLoader();

    updateRepository.getApprovals().then(
          (value) {
        Loader.hideLoader();

        notificationList = (value['data'] as List)
            .map((e) => UpdateItem.fromJson(e))
            .toList();

        update();
      },
      onError: (e) {
        Loader.hideLoader();

        Toast.error(message: e);
      },
    );
  }

  Future<void> getHolidays() async {
    Loader.showLoader();

    updateRepository.getHolidays().then(
          (value) {
        Loader.hideLoader();

        holidayList = (value['data'] as List)
            .map((e) => HolidayData.fromJson(e))
            .toList();

        update();
      },
      onError: (e) {
        Loader.hideLoader();

        Toast.error(message: e);
      },
    );
  }
}
