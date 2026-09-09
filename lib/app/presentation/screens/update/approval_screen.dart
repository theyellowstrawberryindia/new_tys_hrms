/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 2:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 2:04 pm
 *
 */

import 'package:intl/intl.dart';

import '../../../data/controllers/update_controller.dart';
import '../../../packages.dart';
import 'approval_detail_screen.dart';

class ApprovalScreen extends GetView<UpdateController> {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final valueColor = Theme.of(context).colorScheme.onSurface;

    return GetBuilder<UpdateController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshUpdates,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: controller.approvalList.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColor.kBorderColor, height: 1),
            itemBuilder: (context, index) {
              final item = controller.approvalList[index];

              return InkWell(
                onTap: () {
                  Get.to(
                        () => ApprovalDetailScreen(
                      item: item,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// STATUS ICON
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: controller
                              .getStatusColor(item.status ?? "")
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIcon(item.status ?? ""),
                          color: controller.getStatusColor(item.status ?? ""),
                          size: 16,
                        ),
                      ),

                      const SizedBox(width: 18),

                      /// CONTENT
                      Expanded(
                        child: Column(
                          children: [
                            /// TYPE + DATE
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Type",
                                        style: AppTheme.textStyle(
                                          size: 10,
                                          color: AppColor.kGrayTextColor,
                                          weight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        _getType(item.label ?? ""),
                                        style: AppTheme.textStyle(
                                          size: 12,
                                          weight: FontWeight.w600,
                                          color: valueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Date",
                                        style: AppTheme.textStyle(
                                          size: 10,
                                          color: AppColor.kGrayTextColor,
                                          weight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        _getDateText(item),
                                        textAlign: TextAlign.end,
                                        style: AppTheme.textStyle(
                                          size: 12,
                                          weight: FontWeight.w600,
                                          color: valueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            /// REASON
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reason",
                                        style: AppTheme.textStyle(
                                          size: 10,
                                          color: AppColor.kGrayTextColor,
                                          weight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        item.reason ?? "-",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.textStyle(
                                          size: 12,
                                          weight: FontWeight.w600,
                                          color: valueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                _statusChip(
                                  item.status ?? "",
                                  controller.getStatusColor(item.status ?? ""),
                                ),
                              ],
                            ),
                          ],
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
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: AppTheme.textStyle(
          size: 10,
          weight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _getType(String label) {
    switch (label) {
      case "LV":
        return "Leave";

      case "RG":
        return "Regularization";

      case "RM":
        return "Reimbursement";

      default:
        return label;
    }
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "-";
    }

    try {
      DateTime parsedDate;

      /// API FORMAT
      if (date.contains('-') && date.split('-').first.length == 4) {
        parsedDate = DateTime.parse(date);
      }

      /// UI FORMAT (10-3-2025)
      else {
        parsedDate = DateFormat('d-M-yyyy').parse(date);
      }

      return DateFormat('MMMM dd yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String _getDateText(dynamic item) {

    if ((item.startDate ?? "").isNotEmpty &&
        (item.endDate ?? "").isNotEmpty) {

      return "${formatDate(item.startDate)} - ${formatDate(item.endDate)}";
    }

    if ((item.createdAt ?? "").isNotEmpty) {

      return formatDate(item.createdAt);
    }

    return "-";
  }

  IconData _getIcon(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Icons.arrow_outward_rounded;

      case "rejected":
        return Icons.south_east_rounded;

      default:
        return Icons.arrow_back_rounded;
    }
  }
}