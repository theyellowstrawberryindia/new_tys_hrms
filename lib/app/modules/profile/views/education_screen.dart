import '../controllers/education_controller.dart';
import '../../../shared/packages.dart';
import '../../../shared/widgets/common_button.dart';
import '../../../shared/widgets/common_outline_button.dart';
import '../../../shared/widgets/common_confirmation_dialog.dart';
import '../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class EducationDetailsScreen extends GetView<EducationDetailsController> {
  const EducationDetailsScreen({super.key});

  void _handleSave(EducationDetailsController controller) {
    if (controller.isSavingRecords || !controller.validateRecordDrafts()) {
      return;
    }

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
            actionLabel: controller.courseControllers.isEmpty ? 'Add' : 'Edit',
            status: ProfileSaveStatus(
              message: controller.recordSaveMessage,
              succeeded: controller.recordSaveSucceeded,
            ),
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
              if (controller.courseControllers.isEmpty) {
                controller.newEducation();
              }
            },
            onAdd: controller.isEditing && !controller.isSavingRecords
                ? controller.newEducation
                : null,
            fields: [
              ...List.generate(controller.courseControllers.length, (index) {
                final row = controller.courseControllers[index];
                final readOnly =
                    !controller.isEditing ||
                    controller.isSavingRecords ||
                    controller.recordIsLocked(row);

                final bool isNewEntry =
                    index >= controller.currentUser!.education.length;
                final canDelete =
                    !readOnly &&
                    (isNewEntry ||
                        (!controller.hasSavedRows &&
                            !controller.hasExistingFieldEdits &&
                            !controller.isAddPressed));

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
                        key: ObjectKey(row),
                        initiallyExpanded: controller.expandedIndex == index,
                        onExpansionChanged: (expanded) {
                          controller.toggleExpansion(index, expanded);
                        },
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          controller.courseControllers[index].text
                                  .trim()
                                  .isEmpty
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
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        children: [
                          ProfileDetailField(
                            errorText: controller.recordFieldError(
                              row,
                              'course_name',
                            ),
                            title: "Course Name",
                            maxLength: 100,
                            minLength: 2,
                            controller: controller.courseControllers[index],
                            readOnly: readOnly,
                          ),
                          ProfileDetailField(
                            errorText: controller.recordFieldError(
                              row,
                              'university_name',
                            ),
                            title: "University",
                            maxLength: 100,
                            minLength: 2,
                            controller: controller.universityControllers[index],
                            readOnly: readOnly,
                          ),
                          ProfileDetailField(
                            errorText: controller.recordFieldError(
                              row,
                              'grade',
                            ),
                            title: "Grade",
                            controller: controller.gradeControllers[index],
                            readOnly: readOnly,
                          ),
                          ProfileDetailField(
                            errorText: controller.recordFieldError(
                              row,
                              'start_date',
                            ),
                            title: "Start Date",
                            controller: controller.startDateControllers[index],
                            readOnly: readOnly,
                            isDateField: true,
                            onTap: !readOnly
                                ? () => controller.pickStartDate(index)
                                : null,
                          ),
                          ProfileDetailField(
                            errorText: controller.recordFieldError(
                              row,
                              'end_date',
                            ),
                            title: "End Date",
                            controller: controller.endDateControllers[index],
                            readOnly: readOnly,
                            isDateField: true,
                            onTap: !readOnly
                                ? () => controller.pickEndDate(index)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (controller.isSavingRecords)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.isEditing)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: [
                      if (controller.isAddPressed ||
                          controller.hasExistingFieldEdits ||
                          controller.hasSavedRows) ...[
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
