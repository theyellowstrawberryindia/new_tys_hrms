/*
 *  Created by Yellow Strawberry LLP on 26/05/26, 3:20 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 26/05/26, 3:20 pm
 *
 */
import 'dart:ui';
import '../packages.dart';

class CommonAttendancePopup {
  static void show({required bool isLate, required String time}) {
    Get.dialog(
      barrierColor: Colors.black.withValues(alpha: 0.15),

      Stack(
        children: [
          /// BACKGROUND BLUR
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.transparent),
          ),

          /// POPUP
          Center(
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);

                final Color borderColor = isLate
                    ? AppColor.kErrorColor
                    : AppColor.kSuccessColor;

                final Color backgroundColor = isLate
                    ? AppColor.kErrorBGColor
                    : AppColor.kSuccessBGColor;

                return AnimatedScale(
                  scale: 1,

                  duration: const Duration(milliseconds: 300),

                  curve: Curves.easeOutBack,

                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),

                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? theme.colorScheme.surface
                          : backgroundColor,

                      borderRadius: BorderRadius.circular(32),

                      border: Border.all(color: borderColor, width: 1.5),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        /// ICON
                        Container(
                          width: 80,
                          height: 80,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            border: Border.all(color: borderColor, width: 4),
                          ),

                          child: Icon(
                            isLate
                                ? Icons.priority_high_rounded
                                : Icons.check_rounded,

                            size: 50,

                            color: borderColor,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// TITLE
                        Text(
                          isLate ? "Oops, you are late today. \nWe hope that next time, you make it on time. \nPlease take it on priority."
                              : "You are on time!",

                          textAlign: TextAlign.center,
                          maxLines: 3,

                          style: AppTheme.textStyle(
                            size: 18,

                            weight: FontWeight.w700,

                            color: theme.colorScheme.onSurface,
                          ).copyWith(
                            decoration: TextDecoration.none,
                            decorationColor: Colors.transparent,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SUBTITLE
                        Text(
                          "Clock in time: $time",

                          textAlign: TextAlign.center,

                          style: AppTheme.textStyle(
                            size: 16,

                            weight: FontWeight.w600,

                            color: AppColor.kGrayTextColor,
                          ).copyWith(
                            decoration: TextDecoration.none,
                            decorationColor: Colors.transparent,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },

                            style: ElevatedButton.styleFrom(
                              elevation: 0,

                              backgroundColor: borderColor,

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            child: Text(
                              "Okay",

                              style: AppTheme.textStyle(
                                size: 16,

                                weight: FontWeight.w700,

                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      barrierDismissible: false,
    );
  }
}
