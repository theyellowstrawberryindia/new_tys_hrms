/*
 *  Created by Yellow Strawberry LLP on 02/06/26, 12:49 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 02/06/26, 12:49 pm
 *
 */

import '../../../data/controllers/attendance_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_textfield.dart';

class ReimbursementScreen extends GetView<AttendanceController> {
  const ReimbursementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Reimbursement"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CommonTextField(
              controller: TextEditingController(),

              hintText: "Select Category",

              focusNode: FocusNode(),

              isFocused: false,

              readOnly: true,
            ),

            const SizedBox(height: 20),

            CommonTextField(
              controller: controller.reimbursementVendorController,

              hintText: "Enter vendor",

              focusNode: FocusNode(),

              isFocused: false,
            ),

            const SizedBox(height: 20),

            CommonTextField(
              controller: controller.reimbursementAmountController,

              hintText: "₹ 0000",

              focusNode: FocusNode(),

              isFocused: false,

              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),

                child: Text(
                  "INR",

                  style: AppTheme.textStyle(weight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 30),

            CommonButton(
              text: "Submit",

              onTap: () {
                // controller.submitReimbursement();
              },
            ),
          ],
        ),
      ),
    );
  }
}
