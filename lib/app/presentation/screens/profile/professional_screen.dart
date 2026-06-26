/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 11:55 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 11:55 am
 *
 */

import '../../../data/controllers/profile_controller.dart';
import '../../../packages.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class ProfessionalScreen extends GetView<ProfileController> {
  const ProfessionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Professional",

          isEditing: controller.isProfessionalEditing,
          showActionButton: false,

          onEditSave: () {
            if (controller.isProfessionalEditing) {
              controller.updateProfessional();
            } else {
              controller.enableProfessionalEdit();
            }
          },

          fields: [
            ProfileDetailField(
              title: "Designation",
              controller: controller.designationController,
              readOnly: !controller.isProfessionalEditing,
            ),

            ProfileDetailField(
              title: "Total Experience",
              controller: controller.experienceController,
              readOnly: !controller.isProfessionalEditing,
            ),

            ProfileDetailField(
              title: "Skills",
              controller: controller.skillsController,
              readOnly: !controller.isProfessionalEditing,
            ),

            ProfileDetailField(
              title: "Joining Date",
              controller: controller.joiningDateController,
              readOnly: !controller.isProfessionalEditing,
            ),

            ProfileDetailField(
              title: "Experience In TYS",
              controller: controller.tysExperienceController,
              readOnly: !controller.isProfessionalEditing,
            ),
          ],
        );
      },
    );
  }
}