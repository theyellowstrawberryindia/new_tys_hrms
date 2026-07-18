import '../../../data/controllers/project_details_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_confirmation_dialog.dart';
import '../../../widgets/profile_detail_field.dart';
import 'profile_detail_screen.dart';

class ProjectDetailsScreen extends GetView<ProjectDetailsController> {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectDetailsController>(
      builder: (controller) {
        return PopScope(
          canPop: !controller.isEditing,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            controller.cancelEdit();
          },
          child: ProfileDetailScreen(
            title: "Projects",
            isEditing: controller.isEditing,
            showActionButton: true,
            wrapInCard: false,
            onBack: () {
              if (controller.isEditing) {
                controller.cancelEdit();
              } else {
                Get.back();
              }
            },
            onEditSave: () {
              if (controller.isEditing) {
                if (!controller.validateProjectFields()) {
                  controller.showValidationErrors = true;
                  controller.update();
                  return;
                }

                controller.showValidationErrors = false;

                CommonConfirmationDialog.show(
                  title: "Save Changes",
                  message: "Save changes to your project details?",
                  positiveText: "Save",
                  negativeText: "Cancel",
                ).then((confirmed) {
                  if (confirmed) {
                    controller.saveProjects();
                  }
                });
              } else {
                controller.enableEdit();
              }
            },
            fields: [
              ...List.generate(controller.titleControllers.length, (index) {
                final bool canDelete = controller.isEditing;

                final bool isNewEntry =
                    index >= controller.currentUser!.projects.length;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        key: ValueKey(index),
                        initiallyExpanded:
                        controller.expandedIndex == index,
                        onExpansionChanged: (expanded) {
                          controller.toggleExpansion(index, expanded);
                        },
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        title: Text(
                          controller.titleControllers[index].text.trim().isEmpty
                              ? "New Project Details"
                              : controller.titleControllers[index].text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.textStyle(
                            weight: FontWeight.w600,
                          ),
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
                                    controller.removeNewProject(index);
                                    return;
                                  }

                                  final confirmed =
                                  await CommonConfirmationDialog.show(
                                    title: "Delete Project",
                                    message:
                                    "Are you sure you want to delete this project?",
                                    positiveText: "Delete",
                                    negativeText: "Cancel",
                                    positiveColor: Colors.red,
                                  );

                                  if (confirmed) {
                                    controller.deleteProject(index);
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
                            title: "Project Title",
                            maxLength: 100,
                            minLength: 2,
                            controller: controller.titleControllers[index],
                            readOnly: !controller.isEditing,
                            forceValidate: controller.showValidationErrors,
                          ),
                          ProfileDetailField(
                            title: "Project Description",
                            maxLength: 100,
                            minLength: 2,
                            controller:
                            controller.descriptionControllers[index],
                            readOnly: !controller.isEditing,
                            forceValidate: controller.showValidationErrors,
                          ),
                          ProfileDetailField(
                            title: "Start Date",
                            controller:
                            controller.startDateControllers[index],
                            readOnly: !controller.isEditing,
                            isDateField: true,
                            forceValidate: controller.showValidationErrors,
                            onTap: controller.isEditing
                                ? () => controller.pickStartDate(index)
                                : null,
                          ),
                          ProfileDetailField(
                            title: "End Date",
                            controller: controller.endDateControllers[index],
                            readOnly: !controller.isEditing,
                            isDateField: true,
                            forceValidate: controller.showValidationErrors,
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
                  child: CommonButton(
                    text: "Add Project",
                    onTap: controller.newProject,
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