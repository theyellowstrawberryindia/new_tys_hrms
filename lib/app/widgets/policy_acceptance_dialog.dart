/*
 *  Created by Yellow Strawberry LLP
 *  Copyright (c) 2026 . All rights reserved.
 */


import '../data/controllers/privacy_policy_controller.dart';
import '../presentation/screens/profile/privacy_policy_screen.dart';
import '../widgets/common_confirmation_dialog.dart';
import '../packages.dart';
import 'common_button.dart';
class PolicyAcceptanceDialog extends GetView<PolicyController> {
  const PolicyAcceptanceDialog({super.key});

  Future<void> _readPolicy() async {
    // Push the full policy screen so the user can read it. That screen
    // shares the same PolicyController, so if they accept from there,
    // controller.isPolicyAccepted flips and this dialog auto-closes below.
    await Get.to(() => const PrivacyPolicyScreen());
  }

  Future<void> _handleAccept() async {
    if (controller.isPolicyAccepted || !controller.isCheckboxChecked) return;

    final confirmed = await CommonConfirmationDialog.show(
      title: "Accept Policy",
      message:
      "Once accepted, this cannot be undone. Do you agree to abide by "
          "the company's policies and guidelines?",
      positiveText: "Accept",
      negativeText: "Cancel",
    );

    if (confirmed) {
      await controller.acceptPolicy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PolicyController>(
      builder: (controller) {
        // Safety net: if acceptance is confirmed (from here or from the
        // full-screen read flow), close the gate automatically.
        if (controller.isPolicyAccepted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.isDialogOpen ?? false) Get.back();
          });
        }

        final isDark = Get.isDarkMode;
        final textColor = AppTheme.textColor(context);

        return PopScope(
          // Hard-blocks the system/gesture back button. Combined with the
          // caller's `barrierDismissible: false`, there is no way out
          // except accepting the policy.
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColor.kDarkCardColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.privacy_tip_rounded,
                      size: 44,
                      color: AppColor.kPrimaryColor,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Privacy Policy",
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle(
                        size: 20,
                        weight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Please review and accept our company policy to "
                          "continue using the app.",
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle(
                        size: 14,
                        color: AppColor.kGrayTextColor,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Read full policy link ──
                    GestureDetector(
                      onTap: _readPolicy,
                      child: Text(
                        "Read Privacy Policy",
                        style: AppTheme.textStyle(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColor.kPrimaryColor,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── Agree checkbox ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: controller.isCheckboxChecked,
                          activeColor: isDark?  Colors.white : AppColor.kPrimaryColor,
                          checkColor: isDark ? AppColor.kDarkCardColor : Colors.white,
                          side: BorderSide(color: isDark?  Colors.white: Colors.black, width: 1.5),
                          onChanged: (value) =>
                              controller.toggleCheckbox(value ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.toggleCheckbox(
                              !controller.isCheckboxChecked,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "I agree to the company's policies and guidelines.",
                                style: AppTheme.textStyle(
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // ── Accept button ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Opacity(
                        opacity: controller.isCheckboxChecked ? 1 : 0.5,
                        child: IgnorePointer(
                          ignoring: !controller.isCheckboxChecked,
                          child: CommonButton(
                            text: "Accept Policy",
                            onTap: () => _handleAccept(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}