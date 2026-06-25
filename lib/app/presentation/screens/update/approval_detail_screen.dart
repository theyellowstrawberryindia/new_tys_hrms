/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 4:17 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 4:17 pm
 *
 */

import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';

class ApprovalDetailScreen extends StatelessWidget {
  const ApprovalDetailScreen({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final isLeave = item.label == "LV";

    final isReimbursement = item.label == "RM";

    return Scaffold(
      appBar: const CommonAppBar(title: "Details"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              isLeave
                  ? "Leave Type"
                  : isReimbursement
                  ? "Reimbursement"
                  : "Regularization",
              style: AppTheme.textStyle(size: 16, weight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            _topCard(),

            const SizedBox(height: 30),

            Text(
              "Activity",
              style: AppTheme.textStyle(size: 18, weight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            _timeline(),
          ],
        ),
      ),
    );
  }

  Widget _topCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color(0xFF2B2B2B)
            : const Color(0xFFF4F4F4),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          if (item.label == "LV") ...[
            Text(
              "${item.startDate} - ${item.endDate}",
              style: AppTheme.textStyle(size: 20, weight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            Text(
              item.comment ?? "",
              style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
            ),
          ] else if (item.label == "RM") ...[
            Text(
              "₹ ${item.amount ?? "0"}",
              style: AppTheme.textStyle(size: 20, weight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            Text(
              item.category ?? "",
              style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
            ),
          ] else ...[
            Text(
              item.attDate ?? "",
              style: AppTheme.textStyle(size: 20, weight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            Text(
              _getType(item.label ?? ""),
              style: AppTheme.textStyle(
                color: AppColor.kGrayTextColor,
              ),
            )
          ],

          const SizedBox(height: 16),

          Divider(color: AppColor.kBorderColor),

          const SizedBox(height: 12),

          Text("Reason", style: AppTheme.textStyle(weight: FontWeight.w600)),

          const SizedBox(height: 8),

          Text(item.reason ?? "-", style: AppTheme.textStyle()),
        ],
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

  Widget _timeline() {
    final approved = item.status?.toLowerCase() == "approved";

    final rejected = item.status?.toLowerCase() == "rejected";

    return Column(
      children: [
        _timelineItem(
          title: "Request raised by You",

          date: item.createdAt ?? "",

          active: true,

          showLine: true,
        ),

        _timelineItem(
          title: "Waiting for Approval",

          date: approved || rejected ? item.updatedAt ?? "-" : "-",

          active: approved || rejected,

          showLine: approved || rejected,
        ),

        if (approved)
          _timelineItem(
            title: "Approved by Manager",

            date: item.updatedAt ?? "",

            active: true,

            showLine: false,
          ),

        if (rejected)
          _timelineItem(
            title: "Rejected by Manager",

            date: item.updatedAt ?? "",

            active: true,

            showLine: false,
          ),
      ],
    );
  }

  Widget _timelineItem({
    required String title,

    required String date,

    required bool active,

    required bool showLine,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 36,

            child: Column(
              children: [
                Container(
                  width: 18,

                  height: 18,

                  decoration: BoxDecoration(
                    color: active
                        ? AppColor.kPrimaryColor
                        : Colors.grey.shade300,

                    shape: BoxShape.circle,
                  ),
                ),

                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,

                      color: active
                          ? AppColor.kPrimaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text.rich(
                    TextSpan(
                      text: title,

                      style: AppTheme.textStyle(
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    date,
                    style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
