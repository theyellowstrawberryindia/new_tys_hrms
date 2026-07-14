/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 12:03 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 12:03 pm
 *
 */

// profile_detail_screen.dart

import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';

class ProfileDetailScreen extends StatelessWidget {
  final String title;

  final bool isEditing;

  final bool wrapInCard;

  final VoidCallback? onEditSave;

  final List<Widget> fields;

  final bool showActionButton;


  const ProfileDetailScreen({
    super.key,
    required this.title,
    required this.isEditing,
    required this.fields,
    this.onEditSave,
    this.showActionButton = true,
    this.wrapInCard = true,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CommonAppBar(
        title: title,

        action: showActionButton
            ? TextButton(
          onPressed: onEditSave,

          child: Text(
            isEditing ? "Save" : "Edit",
            style: AppTheme.textStyle(
              color: AppColor.kPrimaryColor,
              weight: FontWeight.w700,
            ),
          ),
        )
            : null,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child:
        wrapInCard?
        Card(
          elevation: 2,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            children: fields,
          ),
        )
            :Column(
          children: fields,
        ),
      ),
    );
  }
}