/*
 *  Created by Yellow Strawberry LLP on 23/06/26, 3:24 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/06/26, 3:24 pm
 *
 */

import '../constants/notification_label.dart';
import '../utils/app_storage.dart';
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../modules/updates/controllers/update_controller.dart';
import '../../shared/packages.dart';
import '../../modules/dashboard/views/dashboard_screen.dart';

class NotificationPayloadHandler {
  NotificationPayloadHandler._();

  static final instance = NotificationPayloadHandler._();

  bool isForeground = true;

  void handle(Map<String, dynamic> payload) {
    debugPrint("FCM DATA => $payload");

    if (!AppStorage.isLoggedIn()) {
      AppStorage.instance.setValue("pending_notification", payload);

      return;
    }

    _navigate(payload);
  }

  void _navigate(Map<String, dynamic> payload) {
    final label = payload['label']?.toString() ?? "";

    Get.until((route) => route.isFirst);

    if (!Get.isRegistered<DashboardController>()) {
      Get.offAll(() => const DashboardScreen(), binding: DashboardBinding());
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      final dashboard = Get.find<DashboardController>();

      switch (label) {
        /// Leave
        case NotificationLabel.leave:
          dashboard.changeTab(2);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(0);
          }
          break;

        /// Regularization
        case NotificationLabel.regularization:
          dashboard.changeTab(2);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(0);

          }
          break;

        /// Reimbursement
        case NotificationLabel.reimbursement:
          dashboard.changeTab(2);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(0);
          }
          break;

        /// Birthday
        case NotificationLabel.birthday:
          dashboard.changeTab(2);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(2);
          }
          break;

        /// General Notification
        case NotificationLabel.general:
          dashboard.changeTab(0);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(2);
          }
          break;

        default:
          dashboard.changeTab(2);

          if (Get.isRegistered<UpdateController>()) {
            final controller = Get.find<UpdateController>();
            controller.refreshUpdates();
            controller.changeTab(2);
          }
      }

      debugPrint("Notification Navigation => Label: $label");
    });
  }
}
