import '../../../data/controllers/education_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_outline_button.dart';
import '../../../widgets/common_confirmation_dialog.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class EducationDetailsScreen extends GetView<EducationDetailsController> {
  const EducationDetailsScreen({super.key});

  void _handleSave(EducationDetailsController controller) {
    if (!controller.validateEducationFields()) {
      controller.showValidationErrors = true;
      controller.update();
      return;
    }

    controller.showValidationErrors = false;

    CommonConfirmationDialog.show(
      title: "Save Changes",
      message: "Save changes to your education details?",
      positiveText: "Save",
      negativeText: "Cancel",
    ).then((confirmed) {
      if (confirmed) {
        controller.saveEducation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EducationDetailsController>(
      builder: (controller) {
        return PopScope(
          canPop: !controller.isEditing,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            controller.cancelEdit();
          },
          child: ProfileDetailScreen(
            title: "Education",
            isEditing: controller.isEditing,
            showActionButton: !controller.isEditing,
            wrapInCard: false,
            onBack: () {
              if (controller.isEditing) {
                controller.cancelEdit();
              } else {
                Get.back();
              }
            },
            onEditSave: () {
              controller.enableEdit();
            },
            onAdd: controller.isEditing ? controller.newEducation : null,
            fields: [
              ...List.generate(controller.courseControllers.length, (index) {
                final bool canDelete = controller.isEditing;

                final bool isNewEntry =
                    index >= controller.currentUser!.education.length;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        key: ValueKey(index),
                        initiallyExpanded: controller.expandedIndex == index,
                        onExpansionChanged: (expanded) {
                          controller.toggleExpansion(index, expanded);
                        },
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          controller.courseControllers[index].text.trim().isEmpty
                              ? "New Education"
                              : controller.courseControllers[index].text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.textStyle(weight: FontWeight.w600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (canDelete)
                              IconButton(
                                splashRadius: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  if (isNewEntry) {
                                    controller.removeNewEducation(index);
                                    return;
                                  }

                                  final confirmed =
                                  await CommonConfirmationDialog.show(
                                    title: "Delete Education",
                                    message:
                                    "Are you sure you want to delete this education entry?",
                                    positiveText: "Delete",
                                    negativeText: "Cancel",
                                    positiveColor: Colors.red,
                                  );

                                  if (confirmed) {
                                    controller.deleteEducation(index);
                                  }
                                },
                              ),
                            const SizedBox(width: 4),
                            Icon(
                              controller.expandedIndex == index
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                        childrenPadding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          ProfileDetailField(
                            title: "Course Name",
                            maxLength: 100,
                            minLength: 2,
                            forceValidate: controller.showValidationErrors,
                            controller: controller.courseControllers[index],
                            readOnly: !controller.isEditing,
                          ),
                          ProfileDetailField(
                            title: "University",
                            maxLength: 100,
                            minLength: 2,
                            forceValidate: controller.showValidationErrors,
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
                            forceValidate: controller.showValidationErrors,
                            isDateField: true,
                            onTap: controller.isEditing
                                ? () => controller.pickStartDate(index)
                                : null,
                          ),
                          ProfileDetailField(
                            title: "End Date",
                            forceValidate: controller.showValidationErrors,
                            controller: controller.endDateControllers[index],
                            readOnly: !controller.isEditing,
                            isDateField: true,
                            onTap: controller.isEditing
                                ? () => controller.pickEndDate(index)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (controller.isEditing)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: [
                      if (controller.isAddPressed ||
                          controller.hasExistingFieldEdits) ...[
                        CommonButton(
                          text: "Save Education",
                          onTap: () => _handleSave(controller),
                        ),
                        const SizedBox(height: 12),
                      ],
                      CommonOutlineButton(
                        text: "Cancel",
                        onTap: controller.cancelEdit,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}