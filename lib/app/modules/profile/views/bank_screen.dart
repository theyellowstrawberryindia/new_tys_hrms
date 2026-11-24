/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 11:56 am
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 11:56 am
 *
 */

import '../controllers/profile_controller.dart';
import '../../../shared/packages.dart';
import '../../../shared/widgets/common_image_preview.dart';
import '../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class BankScreen extends GetView<ProfileController> {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        final readOnly = !controller.isBankEditing || controller.isSavingBank;
        final errors = controller.bankFieldErrors;
        final message = controller.bankSaveMessage;

        return ProfileDetailScreen(
          title: "Bank",

          isEditing: controller.isBankEditing,
          actionLabel: controller.isSavingBank
              ? "Saving…"
              : controller.isBankEditing
              ? "Save"
              : controller.hasBankDetails
              ? "Edit"
              : "Add",

          onEditSave: controller.isSavingBank
              ? null
              : () {
                  if (controller.isBankEditing) {
                    controller.updateBank();
                  } else {
                    controller.enableBankEdit();
                  }
                },

          status: ProfileSaveStatus(
            message: message,
            succeeded: controller.bankSaveSucceeded,
          ),
          fields: [
            ProfileDetailField(
              title: "Account Holder Name",
              controller: controller.accountHolderController,
              readOnly: readOnly,
              errorText: errors['name_as_bank'],
            ),

            ProfileDetailField(
              title: "Bank Name",
              controller: controller.bankNameController,
              readOnly: readOnly,
              errorText: errors['bank_name'],
            ),

            ProfileDetailField(
              title: "Account Number",
              controller: controller.accountNumberController,
              readOnly: readOnly,
              errorText: errors['account_no'],
            ),

            ProfileDetailField(
              title: "IFSC Code",
              controller: controller.ifscController,
              readOnly: readOnly,
              errorText: errors['ifsc_code'],
            ),

            ProfileDetailField(
              title: "Branch Name",
              controller: controller.branchController,
              readOnly: readOnly,
              errorText: errors['branch_name'],
            ),

            ProfileDetailField(
              title: "PAN Number",
              controller: controller.panController,
              readOnly: readOnly,
              errorText: errors['pan_card'],
            ),
            ProfileDetailField(
              title: "Aadhaar Number",

              controller: controller.aadharController,

              readOnly: readOnly,
              errorText: errors['aadhar_card'],
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
                onPressed: readOnly ? null : controller.pickPanCardImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload PAN Card"),
              ),

            if (errors['pan_img'] case final error?)
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
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
                onPressed: readOnly ? null : controller.pickAadharCardImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Aadhaar Card"),
              ),
            if (errors['aadhar_img'] case final error?)
              Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        );
      },
    );
  }
}
