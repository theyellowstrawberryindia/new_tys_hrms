/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 12:03 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 12:03 pm
 *
 */

// profile_detail_screen.dart

import '../../../shared/packages.dart';
import '../../../shared/widgets/common_app_bar.dart';

class ProfileDetailScreen extends StatelessWidget {
  final String title;

  final bool isEditing;

  final bool wrapInCard;

  final VoidCallback? onAdd;

  final VoidCallback? onEditSave;
  final String? actionLabel;
  final VoidCallback? onBack;

  final List<Widget> fields;
  final Widget? status;

  final bool showActionButton;

  const ProfileDetailScreen({
    super.key,
    required this.title,
    required this.isEditing,
    required this.fields,
    this.status,
    this.onEditSave,
    this.actionLabel,
    this.showActionButton = true,
    this.wrapInCard = true,
    this.onBack,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: title,
        onBack: onBack,
        actions: [
          if (onAdd != null)
            IconButton(
              icon: const Icon(Icons.add),
              color: AppTheme.primaryColor(context),
              onPressed: onAdd,
            ),
          if (showActionButton)
            TextButton(
              onPressed: onEditSave,
              child: Text(
                actionLabel ?? "Edit",
                style: AppTheme.textStyle(
                  weight: FontWeight.w600,
                  color: AppTheme.primaryColor(context),
                ),
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          ?status,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: wrapInCard
                  ? Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(children: fields),
                    )
                  : Column(children: fields),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSaveStatus extends StatelessWidget {
  const ProfileSaveStatus({
    super.key,
    required this.message,
    required this.succeeded,
  });

  final String? message;
  final bool succeeded;

  @override
  Widget build(BuildContext context) {
    final text = message;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Semantics(
        liveRegion: true,
        child: Text(
          text,
          style: TextStyle(
            color: succeeded
                ? AppColor.kSuccessColor
                : Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
