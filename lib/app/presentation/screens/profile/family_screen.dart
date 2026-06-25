/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 11:56 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 11:56 am
 *
 */

import '../../../data/controllers/profile_controller.dart';
import '../../../packages.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class FamilyScreen extends GetView<ProfileController> {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Family",

          isEditing: controller.isFamilyEditing,
          showActionButton: false,

          onEditSave: () {
            if (controller.isFamilyEditing) {
              controller.updateFamily();
            } else {
              controller.enableFamilyEdit();
            }
          },

          fields: [
            ProfileDetailField(
              title: "Father's Name",
              controller: controller.fatherNameController,
              readOnly: !controller.isFamilyEditing,
            ),

            ProfileDetailField(
              title: "Mother's Name",
              controller: controller.motherNameController,
              readOnly: !controller.isFamilyEditing,
            ),

            ProfileDetailField(
              title: "Alternate Contact",
              controller: controller.alternateContactController,
              readOnly: !controller.isFamilyEditing,
            ),

            ProfileDetailField(
              title: "Family Address",
              controller: controller.familyAddressController,
              readOnly: !controller.isFamilyEditing,
            ),
          ],
        );
      },
    );
  }
}
