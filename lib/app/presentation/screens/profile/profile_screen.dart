/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:31 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:31 pm
 *
 */

import 'package:hrms_ys/app/widgets/common_app_bar.dart';

import '../../../data/controllers/profile_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_social_icon.dart';
import '../../../widgets/common_svg_icon.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Profile", showBackButton: false),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                // /// TITLE
                // Text(
                //   "Profile",
                //   style: AppTheme.textStyle(size: 24, weight: FontWeight.w700),
                // ),
                //
                // const SizedBox(height: 25),

                /// PROFILE IMAGE
                Stack(
                  alignment: Alignment.bottomRight,

                  children: [
                    Container(
                      width: 142,
                      height: 142,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),

                      child: ClipOval(
                        child: controller.profileImageUrl.isNotEmpty
                            ? Image.network(
                                controller.profileImageUrl,
                                fit: BoxFit.cover,
                                key: ValueKey(controller.profileImageUrl),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;

                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (_, __, ___) {
                                  return Image.asset(
                                    AssetPath.defaultProfile,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                AssetPath.defaultProfile,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    InkWell(
                      onTap: controller.changeProfilePhoto,

                      child: Container(
                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  controller.userName,
                  style: AppTheme.textStyle(size: 24, weight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text(
                  controller.designation,
                  style: AppTheme.textStyle(
                    size: 16,
                    color: AppColor.kGrayTextColor,
                    weight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 40),

                /// MY ACCOUNT
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "MY ACCOUNT",
                    style: AppTheme.textStyle(
                      size: 10,
                      color: AppColor.kGrayTextColor,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                GridView.count(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  crossAxisCount: 3,

                  mainAxisSpacing: 15,

                  crossAxisSpacing: 15,

                  childAspectRatio: .95,

                  children: [
                    _menuCard(
                      context,
                      title: "ID Card",
                      icon: AssetPath.idCardIcon,
                      onTap: controller.openIdCard,
                    ),

                    _menuCard(
                      context,
                      title: "Contact",
                      icon: AssetPath.contactIcon,
                      onTap: controller.openContact,
                    ),

                    _menuCard(
                      context,
                      title: "Professional",
                      icon: AssetPath.professionalIcon,
                      onTap: controller.openProfessional,
                    ),

                    _menuCard(
                      context,
                      title: "Personal",
                      icon: AssetPath.personalIcon,
                      onTap: controller.openPersonal,
                    ),

                    _menuCard(
                      context,
                      title: "Bank",
                      icon: AssetPath.bankIcon,
                      onTap: controller.openBank,
                    ),

                    _menuCard(
                      context,
                      title: "Family",
                      icon: AssetPath.familyIcon,
                      onTap: controller.openFamily,
                    ),
                    _menuCard(
                      context,
                      title: "Education",
                      icon: AssetPath.educationDetails,
                      onTap: controller.openEducation,
                    ),
                    _menuCard(
                      context,
                      title: "Project",
                      icon: AssetPath.projectDetails,
                      onTap: controller.openProject,
                    ),
                    _menuCard(
                      context,
                      title: "Apply Leave",
                      icon: AssetPath.applyLeaveIcon,
                      onTap: controller.openApplyLeave,
                    ),
                    _menuCard(
                      context,
                      title: "Holiday List",
                      icon: AssetPath.holidayIcon,
                      onTap: controller.openHoliday,
                    ),

                  ],
                ),

                const SizedBox(height: 35),

                /// SETTINGS
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "SETTINGS",
                    style: AppTheme.textStyle(
                      size: 10,
                      color: AppColor.kGrayTextColor,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _settingCard(
                        context,
                        title: "Notifications",
                        icon: Icons.notifications_none_rounded,
                        onTap: controller.notificationSetting,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _settingCard(
                        context,
                        title: "Display Mode",
                        icon: Icons.dark_mode_outlined,
                        onTap: controller.toggleTheme,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// LOGOUT
                InkWell(
                  onTap: controller.logout,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),

                    decoration: _cardDecoration(context),

                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.secondary,
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Logout",
                          style: AppTheme.textStyle(
                            size: 14,
                            weight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),

                        const Spacer(),

                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                Text(
                  "FOLLOW US ON",
                  style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
                ),

                const SizedBox(height: 20),

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
                      url:
                          "https://www.linkedin.com/company/theyellowstrawberry/",
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

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        decoration: _cardDecoration(context),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            CommonSvgIcon(
              asset: icon,
              size: 28,
              color: Theme.of(context).colorScheme.secondary,
            ),

            const SizedBox(height: 15),

            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.textStyle(
                size: 10,
                weight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),

        decoration: _cardDecoration(context),

        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.secondary),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                style: AppTheme.textStyle(
                  size: 10,
                  color: Theme.of(context).colorScheme.secondary,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,

      borderRadius: BorderRadius.circular(18),

      boxShadow: [
        BoxShadow(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),

          blurRadius: 10,

          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
