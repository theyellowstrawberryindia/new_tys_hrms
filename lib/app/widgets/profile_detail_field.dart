/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 12:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 12:04 pm
 *
 */

// profile_detail_field.dart

import '../packages.dart';
import 'common_textfield.dart';

class ProfileDetailField extends StatelessWidget {
  final String title;

  final TextEditingController controller;

  final bool readOnly;
  final VoidCallback? onTap;


  const ProfileDetailField({
    super.key,
    required this.title,
    required this.controller,
    required this.readOnly, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: AppTheme.textStyle(
              size: 12,
              color: AppColor.kGrayTextColor,
            ),
          ),

          const SizedBox(height: 8),

          CommonTextField(
            controller: controller,
            hintText: "",
            readOnly: readOnly,
            focusNode: FocusNode(),
            isFocused: false,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}