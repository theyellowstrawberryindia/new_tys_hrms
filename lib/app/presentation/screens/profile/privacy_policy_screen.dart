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
    final isDark = Get.isDarkMode;
    final bgColor = isDark ? AppColor.kDarkPrimaryBGColor : AppColor.kLightPrimaryBGColor;
    final textColor = AppTheme.textColor(context);
    final primaryColor = AppTheme.primaryColor(context);

    return GetBuilder<PolicyController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CommonAppBar(title: "Company Policy"),
          backgroundColor: bgColor,
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.policy == null
              ? Center(
            child: Text(
              "Policy unavailable.",
              style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
            ),
          )
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
                        color: textColor,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      "table": Style(
                        border: Border.all(color: primaryColor),
                      ),
                      "td": Style(
                        padding: HtmlPaddings.all(8),
                        border: Border.all(color: AppColor.kBorderColor),
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
                            activeColor: primaryColor,
                            checkColor: isDark ? AppColor.kDarkCardColor : Colors.white,
                            side: BorderSide(
                              color: textColor,
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
                                  style: AppTheme.textStyle(size: 12, color: textColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: controller.isPolicyAccepted
                            ? ElevatedButton(
                          onPressed: null, // Disabled
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          child: Text("Policy Accepted",style: AppTheme.textStyle(
                            size: 22,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          ),
                        )
                            :
                        CommonButton(
                          text: "Accept Policy",
                          onTap: () => controller.isCheckboxChecked?_handleAccept(controller): null,


                        ),
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