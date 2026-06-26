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

class ContactScreen extends GetView<ProfileController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Contact",

          isEditing: controller.isContactEditing,
          showActionButton: false,

          onEditSave: () {
            if (controller.isContactEditing) {
              controller.updateContact();
            } else {
              controller.enableContactEdit();
            }
          },

          fields: [
            ProfileDetailField(
              title: "Email",
              controller: controller.contactEmailController,
              readOnly: !controller.isContactEditing,
            ),

            ProfileDetailField(
              title: "Phone Number",
              controller: controller.contactPhoneController,
              readOnly: !controller.isContactEditing,
            ),
          ],
        );
      },
    );
  }
}