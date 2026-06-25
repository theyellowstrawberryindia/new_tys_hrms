/*
 *  Created by Yellow Strawberry LLP on 02/06/26, 12:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 02/06/26, 12:37 pm
 *
 */

import '../packages.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final bool showBackButton;

  final VoidCallback? onBack;

  final Widget? action;

  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.action,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,

      automaticallyImplyLeading: false,

      leading: showBackButton
          ? IconButton(
              onPressed: onBack ?? () => Get.back(),

              icon: const Icon(Icons.arrow_back_ios_new),
            )
          : null,

      title: Text(
        title,

        style: AppTheme.textStyle(size: 20, weight: FontWeight.w700),
      ),

      actions: actions ?? [action ?? const SizedBox(width: 50)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
