/*
 *  Created by Yellow Strawberry LLP on 29/05/26, 4:50 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 29/05/26, 4:50 pm
 *
 */

import 'dart:ui';

import '../packages.dart';


class CommonConfirmationDialog {
  static Future<bool> show({
    required String title,

    required String message,

    String? description,

    String positiveText = "Yes",

    String negativeText = "Cancel",

    Color? positiveColor,

    VoidCallback? onConfirm,
  }) async {
    final theme = Theme.of(Get.context!);

    final result = await Get.dialog<bool>(
      BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: Dialog(
          elevation: 0,

          backgroundColor: Colors.transparent,

          insetPadding: const EdgeInsets.symmetric(horizontal: 30),

          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,

              borderRadius: BorderRadius.circular(30),

              border: Border.all(
                color: AppColor.kPrimaryColor,
                width: 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.08),

                  blurRadius: 20,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                /// BODY
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),

                  child: Column(
                    children: [
                      Text(
                        title,

                        textAlign: TextAlign.center,

                        style: AppTheme.textStyle(
                          size: 22,
                          weight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        message,

                        textAlign: TextAlign.center,

                        style: AppTheme.textStyle(
                          size: 16,
                          weight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      if (description != null) ...[
                        const SizedBox(height: 6),

                        Text(
                          description ?? "",

                          textAlign: TextAlign.center,

                          style: AppTheme.textStyle(
                            size: 14,
                            color: AppColor.kGrayTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Divider(height: 1, color: AppColor.kBorderColor),

                IntrinsicHeight(
                  child: Row(
                    children: [

                      /// CANCEL
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back(result: false);
                          },

                          child: Container(
                            height: 64,

                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? const Color(0xFF4A4A4A)
                                  : const Color(0xFFF3F3F3),

                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                              ),
                            ),

                            alignment: Alignment.center,

                            child: Text(
                              negativeText,

                              style: AppTheme.textStyle(
                                size: 20,
                                weight: FontWeight.w700,
                                color: AppColor.kGrayTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// YES
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back(result: true);
                            onConfirm?.call();
                          },

                          child: Container(
                            height: 64,

                            decoration: const BoxDecoration(
                              color: AppColor.kPrimaryColor,

                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                              ),
                            ),

                            alignment: Alignment.center,

                            child: Text(
                              positiveText,

                              style: AppTheme.textStyle(
                                size: 20,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      barrierDismissible: false,
    );

    return result ?? false;
  }
}
