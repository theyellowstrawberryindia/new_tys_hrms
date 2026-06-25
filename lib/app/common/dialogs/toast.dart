/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:26 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:26 pm
 *
 */

import 'package:hrms_ys/app/packages.dart';

import '../../widgets/label.dart';

class Toast {
  static success({required String message}) {
    _private(message, Colors.green, Icons.check_circle_outline_rounded);
  }

  static warning({required String message}) {
    _private(message, Colors.orange, Icons.info_outline_rounded);
  }

  static error({required String message}) {
    _private(message, Colors.redAccent, Icons.error_outline_rounded);
  }

  static _private(String message, Color color, IconData data) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: AppTheme.textStyle(weight: FontWeight.w500, color: Colors.white),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        borderRadius: 4,
        backgroundColor: color,
        duration: const Duration(milliseconds: 3000),
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: SnackPosition.TOP,
        dismissDirection: DismissDirection.up,
        icon: Icon(data, color: Colors.white),
      ),
    );
  }

  static action(String message, {VoidCallback? onAction, String? actionName = 'Action'}) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: AppTheme.textStyle(weight: FontWeight.w500, color: Colors.white),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        borderRadius: 4,
        backgroundColor: AppColor.kPrimaryColor,
        duration: const Duration(milliseconds: 4000),
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: SnackPosition.TOP,
        dismissDirection: DismissDirection.up,
        icon: Icon(Icons.error_outline_rounded, color: Colors.white),
        mainButton: InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(8.0),
          child: Label(
            text: '$actionName'.toUpperCase(),
            style: AppTheme.textStyle(weight: FontWeight.w500, color: Colors.white),
          ).paddingSymmetric(horizontal: 10, vertical: 4),
        ),
      ),
    );
  }
}
