/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 5:15 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 5:15 pm
 *
 */

import 'dart:io';
import 'package:hrms_ys/app/data/controllers/regularize_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_textfield.dart';
import '../../../widgets/label.dart';

class RegularizeScreen extends GetView<RegularizeController> {
  const RegularizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const CommonAppBar(title: "Regularize"),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Label(text: "Email*"),

                const SizedBox(height: 8),

                CommonTextField(
                  controller: controller.regularizeEmailController,

                  hintText: "",

                  focusNode: FocusNode(),

                  isFocused: false,

                  readOnly: true,
                ),

                const SizedBox(height: 20),

                Label(text: "Date*"),

                const SizedBox(height: 8),

                CommonTextField(
                  controller: controller.regularizeDateController,

                  hintText: "",

                  focusNode: FocusNode(),

                  isFocused: false,

                  readOnly: true,
                ),

                const SizedBox(height: 20),

                Label(text: "Regularization Type*"),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.kPrimaryColor),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: DropdownButtonHideUnderline(
                    child: GetBuilder<RegularizeController>(
                      builder: (c) {
                        return DropdownButton<String>(
                          value: c.selectedRegularizationType,

                          isExpanded: true,

                          items: [
                            DropdownMenuItem(
                              value: "Select",
                              child: Text("Select", style: AppTheme.textStyle()),
                            ),

                            DropdownMenuItem(
                              value: "Fullday",
                              child: Text(
                                "Full Day",
                                style: AppTheme.textStyle(),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "Halfday",
                              child: Text(
                                "Half Day",
                                style: AppTheme.textStyle(),
                              ),
                            ),
                          ],

                          onChanged: (value) {
                            if (value == null) return;
                            c.changeRegularizationType(value);
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Label(text: "Check In Time*"),

                const SizedBox(height: 8),

                CommonTextField(
                  controller: controller.checkInController,

                  hintText: "00:00",

                  focusNode: FocusNode(),

                  isFocused: false,

                  readOnly: true,

                  prefixIcon: const Icon(Icons.access_time),

                  onTap: controller.pickCheckInTime,
                ),

                const SizedBox(height: 20),

                Label(text: "Check Out Time*"),

                const SizedBox(height: 8),

                CommonTextField(
                  controller: controller.checkOutController,

                  hintText: "00:00",

                  focusNode: FocusNode(),

                  isFocused: false,

                  readOnly: true,

                  prefixIcon: const Icon(Icons.access_time),

                  onTap: controller.pickCheckOutTime,
                ),

                const SizedBox(height: 20),

                Label(text: "Reason*"),

                const SizedBox(height: 8),

                TextFormField(
                  controller: controller.regularizeReasonController,

                  maxLines: 4,

                  decoration: InputDecoration(
                    hintText: "Enter reason here",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: AppTheme.textStyle(),
                ),

                const SizedBox(height: 20),

                Label(text: "Choose File (Optional)"),

                const SizedBox(height: 12),

                GetBuilder<RegularizeController>(
                  builder: (c) {
                    return Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            GestureDetector(
                              onTap: controller.pickRegularizeImage,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add_a_photo),
                              ),
                            ),

                            if (c.selectedImage != null)
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(File(c.selectedImage!.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                CommonButton(text: "Submit", onTap: controller.submitRegularize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
