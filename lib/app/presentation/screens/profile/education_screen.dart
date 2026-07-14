/*
 *  Created by Yellow Strawberry LLP on xx/xx/26
 *  Copyright (c) 2026. All rights reserved.
 *
 */

import '../../../data/controllers/education_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class EducationDetailsScreen extends GetView<EducationDetailsController> {
  const EducationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EducationDetailsController>(
      builder: (controller) {
        return ProfileDetailScreen(
          title: "Education",

          isEditing: controller.isEditing,

          showActionButton: true,
          wrapInCard: false,

          onEditSave: () {
            if (controller.isEditing) {
              controller.updateEducation();
            } else {
              controller.enableEdit();
            }
          },

          fields: [
            ...List.generate(
              controller.courseControllers.length,
                  (index) {
                return Card(

                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        ProfileDetailField(
                          title: "Course Name",
                          controller: controller.courseControllers[index],
                          readOnly: !controller.isEditing,
                        ),

                        ProfileDetailField(
                          title: "University",
                          controller: controller.universityControllers[index],
                          readOnly: !controller.isEditing,
                        ),

                        ProfileDetailField(
                          title: "Grade",
                          controller: controller.gradeControllers[index],
                          readOnly: !controller.isEditing,
                        ),

                        ProfileDetailField(
                          title: "Start Date",
                          controller: controller.startDateControllers[index],
                          readOnly: !controller.isEditing,
                          onTap: controller.isEditing
                              ? () => controller.pickStartDate(index)
                              : null,
                        ),

                        ProfileDetailField(
                          title: "End Date",
                          controller: controller.endDateControllers[index],
                          readOnly: !controller.isEditing,
                          onTap: controller.isEditing
                              ? () => controller.pickEndDate(index)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (controller.isEditing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: CommonButton(
                  text: "Add Education",
                  onTap: controller.addEducation,
                ),
              ),          ],
        );
      },
    );
  }
}