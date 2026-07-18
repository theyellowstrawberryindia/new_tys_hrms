import 'package:flutter_html/flutter_html.dart';
import 'package:hrms_ys/app/widgets/common_app_bar.dart';

import '../../../data/controllers/privacy_policy_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_confirmation_dialog.dart';

class PrivacyPolicyScreen extends GetView<PolicyController> {
  const PrivacyPolicyScreen({super.key});

  void _handleAccept(PolicyController controller) {
    if (controller.isPolicyAccepted || !controller.isCheckboxChecked) return;

    CommonConfirmationDialog.show(
      title: "Accept Policy",
      message:
      "Once accepted, this cannot be undone. Do you agree to abide by the company's policies and guidelines?",
      positiveText: "Accept",
      negativeText: "Cancel",
    ).then((confirmed) {
      if (confirmed) {
        controller.acceptPolicy();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PolicyController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(title: "Company Policy"),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.policy == null
              ? const Center(child: Text("Policy unavailable."))
              : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Html(
                    data: controller.policy!.body,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "table": Style(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      "td": Style(
                        padding: HtmlPaddings.all(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    },
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: controller.isPolicyAccepted
                                ? true
                                : controller.isCheckboxChecked,
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: Theme.of(context).colorScheme.primary,
                            side: BorderSide(
                              color: Get.isDarkMode
                                  ? AppColor.kDarkTextColor
                                  : AppColor.kLightTextColor,
                              width: 1.5,
                            ),
                            onChanged: controller.isPolicyAccepted
                                ? null
                                : (value) => controller.toggleCheckbox(
                              value ?? false,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: controller.isPolicyAccepted
                                  ? null
                                  : () => controller.toggleCheckbox(
                                !controller.isCheckboxChecked,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  "I have carefully read, understood, and agree to abide by the company's policies and guidelines.",
                                  style: AppTheme.textStyle(size: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CommonButton(
                        text: controller.isPolicyAccepted
                            ? "Policy Accepted"
                            : "Accept Policy",
                        onTap: () => _handleAccept(controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}