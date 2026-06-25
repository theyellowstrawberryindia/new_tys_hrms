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

class PersonalScreen extends GetView<ProfileController> {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Personal Details",

          isEditing: controller.isPersonalEditing,
          showActionButton: false,

          onEditSave: () {
            if (controller.isPersonalEditing) {
              controller.updatePersonal();
            } else {
              controller.enablePersonalEdit();
            }
          },

          fields: [
            ProfileDetailField(
              title: "Date Of Birth",
              controller: controller.dobController,
              readOnly: !controller.isPersonalEditing,
            ),

            ProfileDetailField(
              title: "Gender",
              controller: controller.genderController,
              readOnly: !controller.isPersonalEditing,
            ),

            ProfileDetailField(
              title: "Blood Group",
              controller: controller.bloodGroupController,
              readOnly: !controller.isPersonalEditing,
            ),

            ProfileDetailField(
              title: "Personal Email",
              controller: controller.personalEmailController,
              readOnly: !controller.isPersonalEditing,
            ),

            ProfileDetailField(
              title: "Address",
              controller: controller.addressController,
              readOnly: !controller.isPersonalEditing,
            ),
          ],
        );
      },
    );
  }
}