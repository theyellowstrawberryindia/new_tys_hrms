/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 2:05 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 2:05 pm
 *
 */

import 'package:intl/intl.dart';

import '../../../data/controllers/update_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';

class NotificationScreen extends GetView<UpdateController> {
  final bool showAppBar;

  const NotificationScreen({super.key,this.showAppBar = false});

  @override
  Widget build(BuildContext context) {

    final body = GetBuilder<UpdateController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshUpdates,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.symmetric(horizontal: 16),

            itemCount: controller.notificationList.length,

            itemBuilder: (context, index) {
              final item = controller.notificationList[index];

              return InkWell(
                onTap: () {
                  controller.openNotificationDetail(item);
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),

                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColor.kBorderColor,
                      ),
                    ),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: 24,
                        height: 24,

                        decoration: BoxDecoration(
                          color: _iconColor(item.label),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          _iconData(item.label),
                          color: Colors.white,
                          size: 16,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              _title(item),

                              style: AppTheme.textStyle(
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.reason ?? "-",

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              style: AppTheme.textStyle(
                                size: 10,
                                color: AppColor.kGrayTextColor,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        _formatDate(item.createdAt),

                        style: AppTheme.textStyle(
                          size: 10,
                          color: AppColor.kGrayTextColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (!showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Notifications",
      ),
      body: body,
    );

  }

  Color _iconColor(String? label) {
    switch (label) {
      case "LV":
        return Colors.green;
      case "RG":
        return Colors.blueAccent;
      case "BD":
        return Colors.deepPurpleAccent;
      case "HD":
        return AppColor.kPrimaryColor;
      default:
        return AppColor.kPrimaryColor;
    }
  }

  IconData _iconData(String? label) {
    switch (label) {
      case "LV":
        return Icons.arrow_outward_rounded;
      case "RG":
        // return Icons.edit_calendar_outlined;
        return Icons.refresh_outlined;
      case "BD":
        return Icons.cake_outlined;
      case "HD":
        return Icons.calendar_month_rounded;
      default:
        return Icons.notifications_none;
    }
  }

  String _title(dynamic item) {
    if (item.label == "LV") {
      return "Leave ${_capitalize(item.status)}";
    }

    if (item.label == "RG") {
      return "Regularization ";
    }

    if (item.label == "BD") {
      return "Birthday Reminder";
    }

    if (item.label == "HD") {
      return "Holiday Reminder";
    }

    return "Notification";
  }

  String _capitalize(String? value) {
    if (value == null || value.isEmpty) return "";
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "-";
    }

    try {
      final parsed = DateTime.parse(date);

      return DateFormat(
        "MMM dd, yyyy",
      ).format(parsed);
    } catch (_) {
      return date;
    }
  }
}