/*
 *  Created by Yellow Strawberry LLP on 22/05/26, 3:47 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 22/05/26, 3:47 pm
 *
 */
import 'package:hrms_ys/app/packages.dart';
import 'package:hrms_ys/app/widgets/label.dart';

import '../../../data/controllers/auth_controller.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_social_icon.dart';
import '../../../widgets/common_textfield.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),

            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  /// LOGO
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        AssetPath.logo,
                        width: 220,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// LOGIN CONTAINER
                  Expanded(
                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 35,
                      ),

                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Theme.of(context).colorScheme.surface
                            : AppColor.kLightPrimaryBGColor,

                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: Get.isDarkMode ? 0.35 : 0.12,
                            ),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),

                      child: Form(
                        key: controller.loginKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            /// EMAIL
                            Label(
                              text: "Username",
                              style: AppTheme.textStyle(
                                size: 14,
                                color: AppColor.kGrayTextColor,
                              ),
                            ),

                            const SizedBox(height: 10),

                            GetBuilder<AuthController>(
                              builder: (controller) {

                                return CommonTextField(
                                  controller: controller.emailController,
                                  hintText: "Enter your work email",
                                  focusNode: controller.emailFocus,
                                  isFocused: controller.isEmailFocused,
                                  validator: controller.validateEmail,
                                );
                              },
                            ),

                            const SizedBox(height: 25),

                            /// PASSWORD
                            Label(
                              text: "Password",

                              style: AppTheme.textStyle(
                                size: 14,
                                color: AppColor.kGrayTextColor,
                              ),
                            ),

                            const SizedBox(height: 10),

                            GetBuilder<AuthController>(
                              builder: (controller) {

                                return CommonTextField(
                                  controller: controller.passwordController,

                                  hintText: "8 digit password",

                                  isPassword: true,

                                  focusNode: controller.passwordFocus,

                                  isFocused: controller.isPasswordFocused,

                                  isPasswordVisible:
                                  controller.isPasswordVisible,

                                  validator:
                                  controller.validatePassword,

                                  onEyeTap: () {
                                    controller.togglePasswordVisibility();
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 40),

                            /// LOGIN BUTTON
                            CommonButton(
                              text: "Login",

                              onTap: () {
                                controller.login();
                              },
                            ),

                            const SizedBox(height: 40),

                            /// FOOTER
                            Center(
                              child: Column(
                                children: [
                                   Text(
                                    "FOLLOW US ON",

                                    style: AppTheme.textStyle(
                                      color: AppColor.kGrayTextColor,
                                      size: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [

                                      CommonSocialIcon(
                                        imagePath: AssetPath.instagramIcon,

                                        url: "https://www.instagram.com/tysindia/",
                                      ),

                                      const SizedBox(width: 15),

                                      CommonSocialIcon(
                                        imagePath: AssetPath.linkedinIcon,

                                        url: "https://www.linkedin.com/company/theyellowstrawberry/",
                                      ),

                                      const SizedBox(width: 15),

                                      CommonSocialIcon(
                                        imagePath: AssetPath.facebookIcon,

                                        url: "https://facebook.com",
                                      ),
                                      const SizedBox(width: 15),

                                      CommonSocialIcon(
                                        imagePath: AssetPath.xIcon,

                                        url: "https://x.com/tysindia",
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.appVersion,
                                    style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
