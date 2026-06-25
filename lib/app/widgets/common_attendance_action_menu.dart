/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 5:11 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 5:11 pm
 *
 */

import '../packages.dart';

class CommonAttendanceActionMenu extends StatelessWidget {
  final VoidCallback onRegularize;

  final VoidCallback onApplyLeave;
  final VoidCallback? onMenuOpen;

  const CommonAttendanceActionMenu({
    super.key,
    required this.onRegularize,
    required this.onApplyLeave,
    this.onMenuOpen,
  });

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      elevation: 8,

      offset: const Offset(-20, 10),

      color: Theme.of(context).colorScheme.surface,

      icon: const Icon(Icons.more_vert, color: AppColor.kGrayTextColor),

      onSelected: (value) {
        switch (value) {
          case "regularize":
            onRegularize();
            break;

          case "leave":
            onApplyLeave();
            break;
        }
      },
      onOpened: () {
        onMenuOpen?.call();
      },

      itemBuilder: (context) => [
        PopupMenuItem(
          value: "regularize",

          child: Row(
            children: [
              Icon(Icons.timeline, color: AppColor.kIconColor, size: 20),

              const SizedBox(width: 12),

              Text(
                "Regularize",
                style: AppTheme.textStyle(weight: FontWeight.w500),
              ),
            ],
          ),
        ),

        PopupMenuItem(
          value: "leave",

          child: Row(
            children: [
              Icon(
                Icons.assignment_ind_outlined,
                color: AppColor.kGrayTextColor,
                size: 20,
              ),

              const SizedBox(width: 12),

              Text(
                "Apply Leave",
                style: AppTheme.textStyle(weight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
