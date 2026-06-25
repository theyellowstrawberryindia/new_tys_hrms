/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 11:56 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 11:56 am
 *
 */

import '../../../data/controllers/profile_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_image_preview.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class BankScreen extends GetView<ProfileController> {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Bank",

          isEditing: controller.isBankEditing,
          showActionButton: false,

          onEditSave: () {
            if (controller.isBankEditing) {
              controller.updateBank();
            } else {
              controller.enableBankEdit();
            }
          },

          fields: [
            ProfileDetailField(
              title: "Account Holder Name",
              controller: controller.accountHolderController,
              readOnly: !controller.isBankEditing,
            ),

            ProfileDetailField(
              title: "Bank Name",
              controller: controller.bankNameController,
              readOnly: !controller.isBankEditing,
            ),

            ProfileDetailField(
              title: "Account Number",
              controller: controller.accountNumberController,
              readOnly: !controller.isBankEditing,
            ),

            ProfileDetailField(
              title: "IFSC Code",
              controller: controller.ifscController,
              readOnly: !controller.isBankEditing,
            ),

            ProfileDetailField(
              title: "Branch Name",
              controller: controller.branchController,
              readOnly: !controller.isBankEditing,
            ),

            ProfileDetailField(
              title: "PAN Number",
              controller: controller.panController,
              readOnly: !controller.isBankEditing,
            ),
            ProfileDetailField(
              title: "Aadhaar Number",

              controller: controller.aadharController,

              readOnly: !controller.isBankEditing,
            ),
            documentPreview(
              title: "PAN Card",
              imageUrl: controller.panCardImageUrl,
              localFile: controller.panCardImageFile,

              onPdfTap: () {
                controller.openPdf(controller.panCardImageUrl);
              },

              onImageTap: () {
                controller.openImage(controller.panCardImageUrl);
              },
            ),
            if (controller.isBankEditing)
              TextButton.icon(
                onPressed: controller.pickPanCardImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload PAN Card"),
              ),

            documentPreview(
              title: "Aadhaar Card",
              imageUrl: controller.aadharCardImageUrl,
              localFile: controller.aadharCardImageFile,

              onPdfTap: () {
                controller.openPdf(controller.aadharCardImageUrl);
              },

              onImageTap: () {
                controller.openImage(controller.aadharCardImageUrl);
              },
            ),

            if (controller.isBankEditing)
              TextButton.icon(
                onPressed: controller.pickAadharCardImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Aadhaar Card"),
              ),
          ],
        );
      },
    );
  }
}
